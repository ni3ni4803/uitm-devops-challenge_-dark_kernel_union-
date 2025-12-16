import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/screens/tenant_home_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/tenant_map_screen.dart'; 
import 'package:rentverse_mobile/features/tenant/screens/wishlist_screen.dart'; 
import 'package:rentverse_mobile/features/tenant/screens/tenant_main_wrapper.dart';
import 'package:rentverse_mobile/features/tenant/screens/property_detail_screen.dart'; 
import 'package:rentverse_mobile/features/auth/screens/login_screen.dart';
import 'package:rentverse_mobile/features/auth/screens/register_screen.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_step_one_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_step_two_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_step_three_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_review_screen.dart';
import 'package:rentverse_mobile/features/auth/screens/profile_edit_screen.dart';
import 'package:rentverse_mobile/features/auth/screens/password_change_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/landlord_home_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_one_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_two_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_three_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/edit_property_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/edit_property_screen.dart';


final _shellNavigatorKey = GlobalKey<NavigatorState>();

// NEW HELPER: We store the root container reference here
late ProviderContainer _rootContainer;

// 1. Define the GoRouter configuration with Redirects
final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    
    // AUTH ROUTES
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    
    // SHELL ROUTE (Protected Main App)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return TenantMainWrapper(child: child); 
      },
      routes: [
        GoRoute(
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TenantHomeScreen(),
        ),
        GoRoute(
          path: '/map',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const TenantMapScreen(),
        ),
        GoRoute(
          path: '/wishlist',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) => const WishlistScreen(), 
        ),
      ],
    ),
    
    // DETAIL ROUTE
    GoRoute(
      path: '/property/:id',
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        return PropertyDetailScreen(propertyId: propertyId);
      },
    ),

    GoRoute(
      path: '/apply/:id', // NEW ROUTE for the application flow
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        // Start the application flow on the first screen (Step 1)
        return ApplicationStepOneScreen(propertyId: propertyId);
      },
    ),

    GoRoute(
      // The path must match what you called in ApplicationStepOneScreen: '/apply/financial/${widget.propertyId}'
      path: '/apply/financial/:id', 
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        return ApplicationStepTwoScreen(propertyId: propertyId);
      },
    ),

    GoRoute(
      // The path must match what you called in ApplicationStepTwoScreen: '/apply/residence/${widget.propertyId}'
      path: '/apply/residence/:id', 
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        return ApplicationStepThreeScreen(propertyId: propertyId);
      },
    ),

    GoRoute(
      // The path must match what you called in ApplicationStepThreeScreen: '/apply/review/${widget.propertyId}'
      path: '/apply/review/:id', 
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        return ApplicationReviewScreen(propertyId: propertyId);
      },
    ),

    GoRoute(
      path: '/profile', // NEW ROUTE for Account Management
      builder: (context, state) => const ProfileEditScreen(),
    ),

    GoRoute(
      path: '/change-password', 
      builder: (context, state) => const PasswordChangeScreen(),
    ),

    GoRoute(
      path: '/landlord',
      builder: (context, state) => const LandlordHomeScreen(),
    ),

    // LANDLORD ADD PROPERTY ROUTE (Step 1)
    GoRoute(
      path: '/landlord/add-property', 
      builder: (context, state) => const AddPropertyStepOneScreen(),
    ),

    // NEW: LANDLORD ADD PROPERTY ROUTE (Step 2)
    GoRoute(
      path: '/landlord/add-property/details', 
      builder: (context, state) => const AddPropertyStepTwoScreen(),
    ),
    // NEW: LANDLORD ADD PROPERTY ROUTE (Step 3)
    GoRoute(
      path: '/landlord/add-property/description', 
      builder: (context, state) => const AddPropertyStepThreeScreen(),
    ),
    // NEW: LANDLORD EDIT PROPERTY ROUTE (Uses the same form steps, but pre-filled)
    GoRoute(
      path: '/landlord/edit-property/:id', // Takes a property ID as a parameter
      builder: (context, state) {
        final propertyId = state.pathParameters['id'];
        if (propertyId == null) {
          return const Scaffold(body: Center(child: Text('Error: Property ID missing')));
        }
        return EditPropertyScreen(propertyId: propertyId);
      },
    ),
  ],
  
  // GLOBAL REDIRECT LOGIC
  redirect: (context, state) {
    // FIX APPLIED: Use the globally available root container
    final ref = _rootContainer;
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final user = ref.read(authNotifierProvider);
    final isLoggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/register';
    
    // 1. If the user is NOT authenticated:
  if (!isAuthenticated && !isLoggingIn) {
    return '/login';
  }

  // 2. If the user IS authenticated:
  if (isAuthenticated) {
    final isTenant = user?.role == 'tenant';
    final isLandlord = user?.role == 'landlord';

    // A. If they are on a public auth page (login/register), send them to their dashboard
    if (isLoggingIn) {
      return isLandlord ? '/landlord' : '/';
    }

    // B. Landlord can access ANY /landlord/* route
if (isLandlord && !state.uri.path.startsWith('/landlord')) {
  return '/landlord';
}

    // C. If a Tenant tries to access the Landlord route
    if (isTenant && state.uri.toString() == '/landlord') {
      return '/';
    }
  }

  return null;
},
  
  // OBSERVE AUTH CHANGES
  refreshListenable: AuthRedirectListenable(
    // FIX APPLIED: Use the globally available root container
    _rootContainer.read(authNotifierProvider.notifier),
  ),
);


// Helper class to expose the AuthState as a Listenable for GoRouter
class AuthRedirectListenable extends ChangeNotifier {
  final AuthNotifier _notifier;
  // FIX 1: Hold the Dispose object returned by the StateNotifier's addListener
  late VoidCallback _disposeListener; 

  AuthRedirectListenable(this._notifier) {
    // FIX 1: Use the 'listen' method (or the signature that returns a cleanup function)
    // The 'listen' method on StateNotifier returns a cleanup function (VoidCallback)
    _disposeListener = _notifier.addListener((state) {
      // We don't care about the 'state' value here, only that it changed.
      notifyListeners();
    }, fireImmediately: true); // fireImmediately ensures GoRouter checks state on startup
  }

  // NOTE: _authStateListener is now unused and can be removed or left as a placeholder

  // FIX 2: Correctly call the stored cleanup function
  @override
  void dispose() {
    _disposeListener(); 
    super.dispose();
  }
}

void main() {
  // FIX APPLIED: Initialize the root container before running the app
  _rootContainer = ProviderContainer();
  runApp(
    // Use the initialized container
    UncontrolledProviderScope(
      container: _rootContainer,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Rentverse Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false, 
      ),
      routerConfig: _router,
    );
  }
}