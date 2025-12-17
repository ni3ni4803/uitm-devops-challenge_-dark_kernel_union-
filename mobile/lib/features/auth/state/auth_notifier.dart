import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/user.dart';

// 1. Define the Authentication State (User or null)
typedef AuthState = User?;

// 2. AuthNotifier manages the login/logout state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(null); // Initial state is null (logged out)

  // Mock User Data
  final User _mockTenantUser = const User( 
    id: 'user-123',
    email: 'tenant@rentverse.com',
    fullName: 'Jane Doe',
    role: 'tenant',
    phoneNumber: '0123456789', // Added mock phone
  );

  final User _mockLandlordUser = const User(
    id: 'landlord-456',
    email: 'landlord@rentverse.com',
    fullName: 'Mark Smith',
    role: 'landlord',
    phoneNumber: '0987654321', // Added mock phone
  );
  
  final User _mockAdminUser = const User(
    id: 'admin-789',
    email: 'admin@rentverse.com',
    fullName: 'Boss Man',
    role: 'admin',
    phoneNumber: '0000000000', // Added mock phone
  );

  // --- NEW: Profile Update Logic for Multiple Fields ---
  /// Updates both name and phone in the global state.
  void updateUserProfile({required String newName, required String newPhone}) {
    if (state != null) {
      state = state!.copyWith(
        fullName: newName,
        phoneNumber: newPhone,
      );
    }
  }

  // Simulates a successful login
  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); 

    if (password != 'password') { 
      throw Exception('Invalid credentials');
    }
    
    if (email == _mockAdminUser.email) {
      state = _mockAdminUser;
    } else if (email == _mockLandlordUser.email) {
      state = _mockLandlordUser;
    } else if (email == _mockTenantUser.email) {
      state = _mockTenantUser;
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // --- MODIFIED: Handles phoneNumber during registration ---
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final combinedName = '$firstName $lastName'.trim();

    // Create a new user state with the phone number included
    state = _mockTenantUser.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email, 
      fullName: combinedName,
      phoneNumber: phoneNumber, // Now correctly saved to state
      role: 'tenant',
    ); 
  }

  void logout() {
    state = null;
  }

  bool isAuthenticated() => state != null;
}

// 3. The Auth Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// 4. A separate provider for easy access to the isAuthenticated status
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) != null;
});