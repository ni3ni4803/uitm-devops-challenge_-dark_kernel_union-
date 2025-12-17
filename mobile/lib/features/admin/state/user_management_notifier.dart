import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/models/app_user.dart';

// 1. Define the state object (list of users)
class UserManagementState {
  final List<AppUser> users;
  final bool isLoading;
  final String? errorMessage;
  final String searchQuery;

  UserManagementState({
    this.users = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  // Helper for copying state with new values
  UserManagementState copyWith({
    List<AppUser>? users,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
  }) {
    return UserManagementState(
      users: users ?? this.users,
      isLoading: isLoading ?? this.isLoading,
      // Ensure errorMessage is reset to null if not provided
      errorMessage: errorMessage, 
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// 2. Define the State Notifier
class UserManagementNotifier extends StateNotifier<UserManagementState> {
  UserManagementNotifier() : super(UserManagementState()) {
    // The fetchUsers() call handles setting the initial state, 
    // so no need to call it in the constructor if you handle it in the screen's build method (init state equivalent)
  }

  // --- API Simulation Data ---
  List<AppUser> _dummyUsers = [
    AppUser(id: 'u001', name: 'Alice Tenant', email: 'alice@mail.com', role: 'tenant', isActive: true, registrationDate: DateTime(2023, 10, 1)),
    AppUser(id: 'u002', name: 'Bob Landlord', email: 'bob@mail.com', role: 'landlord', isActive: true, registrationDate: DateTime(2023, 10, 5)),
    AppUser(id: 'u003', name: 'Charlie Admin', email: 'charlie@mail.com', role: 'admin', isActive: true, registrationDate: DateTime(2023, 11, 15)),
    AppUser(id: 'u004', name: 'Diana Suspended', email: 'diana@mail.com', role: 'tenant', isActive: false, registrationDate: DateTime(2024, 1, 20)),
  ];

  // 3. Methods for fetching data
  Future<void> fetchUsers() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API delay
      
      // Simulate getting fresh data (use the current internal _dummyUsers list)
      state = state.copyWith(users: List.from(_dummyUsers), isLoading: false, errorMessage: null);
      
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to fetch users: $e');
    }
  }
  
  // 🚨 NEW METHOD: Refresh data without showing a full spinner if possible
  Future<void> refreshUsers() async {
    // Keep current state but fetch new data
    state = state.copyWith(errorMessage: null);
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Shorter refresh delay
      state = state.copyWith(users: List.from(_dummyUsers), errorMessage: null);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to refresh users.');
    }
  }

  // 4. Methods for admin actions
  Future<void> toggleUserActiveStatus(String userId) async {
    // --- Optimistic UI update ---
    final newUsers = state.users.map((user) {
      if (user.id == userId) {
        // Create a copy of the user with the toggled status
        return AppUser(
          id: user.id,
          name: user.name,
          email: user.email,
          role: user.role,
          isActive: !user.isActive, // Toggle status
          registrationDate: user.registrationDate,
        );
      }
      return user;
    }).toList();
    state = state.copyWith(users: newUsers);
    
    // 🚨 IMPORTANT: Also update the mock data source for consistency across fetches
    final newDummyUsers = _dummyUsers.map((user) {
        if (user.id == userId) return newUsers.firstWhere((u) => u.id == userId);
        return user;
    }).toList();
    _dummyUsers = newDummyUsers; // Update internal mock source

    // Simulate API call to update status on the backend
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      // If API fails, revert the state change and show error
      state = state.copyWith(errorMessage: 'Failed to update user status.');
      // Revert state by fetching the original data (which hasn't been updated yet)
      fetchUsers(); 
    }
  }
  
  // 🚨 NEW METHOD: Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

// 3. Define the Riverpod provider
final userManagementNotifierProvider = 
    StateNotifierProvider<UserManagementNotifier, UserManagementState>(
  (ref) => UserManagementNotifier(),
);

// 🚨 NEW: A computed provider for filtered users (for optimal performance)
final filteredUsersProvider = Provider<List<AppUser>>((ref) {
  final state = ref.watch(userManagementNotifierProvider);
  
  if (state.searchQuery.isEmpty) {
    return state.users;
  }
  
  final query = state.searchQuery.toLowerCase();
  
  return state.users.where((user) {
    return user.name.toLowerCase().contains(query) ||
           user.email.toLowerCase().contains(query);
  }).toList();
});

