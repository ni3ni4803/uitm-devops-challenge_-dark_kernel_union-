import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/user.dart';

// 1. Define the Authentication State (User or null)
typedef AuthState = User?;

// 2. AuthNotifier manages the login/logout state
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(null); // Initial state is null (logged out)

  // Mock User Data for demonstration
  // RENAMED: _mockTenantUser to clearly differentiate
  final User _mockTenantUser = const User( 
    id: 'user-123',
    email: 'tenant@rentverse.com',
    fullName: 'Jane Doe',
    role: 'tenant', // Explicit role
  );

  // NEW: Mock Landlord Data
  final User _mockLandlordUser = const User(
    id: 'landlord-456',
    email: 'landlord@rentverse.com',
    fullName: 'Mark Smith',
    role: 'landlord', // Explicit role
  );

  // Simulates a successful login after a delay
  Future<void> login(String email, String password) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 800)); 

    // Simple password check for all mock users
    if (password != 'password') { 
      throw Exception('Invalid credentials');
    }
    
    // UPDATED LOGIN LOGIC to check the email and set the appropriate user state
    if (email == _mockLandlordUser.email) {
      state = _mockLandlordUser; // Log in as landlord
    } else if (email == _mockTenantUser.email) {
      state = _mockTenantUser; // Log in as tenant
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Simulates a successful registration (defaulting to tenant)
  Future<void> register(String email, String password) async {
    // In a real app, this would call an API
    await Future.delayed(const Duration(milliseconds: 800));
    // When registering, we'll default the new user to a tenant
    state = _mockTenantUser.copyWith(email: email, fullName: 'New User'); 
  }

  // Logs the user out
  void logout() {
    state = null; // Set state to null (logged out)
  }

  // Simple getter to check if the user is authenticated
  bool isAuthenticated() {
    return state != null;
  }
}

// 3. The Auth Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

// 4. A separate provider for easy access to the isAuthenticated status
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider) != null;
});