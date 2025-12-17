import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Tenant Imports
import 'package:rentverse_mobile/features/tenant/screens/tenant_home_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/tenant_map_screen.dart'; 
import 'package:rentverse_mobile/features/tenant/screens/wishlist_screen.dart'; 
import 'package:rentverse_mobile/features/tenant/screens/tenant_main_wrapper.dart';
import 'package:rentverse_mobile/features/tenant/screens/property_detail_screen.dart'; 
import 'package:rentverse_mobile/features/tenant/screens/application_step_one_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_step_two_screen.dart';
import 'package:rentverse_mobile/features/tenant/screens/application_step_three_screen.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';

// Auth/User Imports
import 'package:rentverse_mobile/features/auth/screens/login_screen.dart';
import 'package:rentverse_mobile/features/auth/screens/register_screen.dart';
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:rentverse_mobile/features/auth/screens/profile_edit_screen.dart';
import 'package:rentverse_mobile/features/auth/screens/password_change_screen.dart';

// Landlord Imports
import 'package:rentverse_mobile/features/landlord/screens/landlord_home_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_one_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_two_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_three_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/edit_property_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/landlord_applications_screen.dart';
import 'package:rentverse_mobile/features/landlord/screens/application_detail_screen.dart';

// Admin Imports
import 'package:rentverse_mobile/features/admin/screens/admin_dashboard_screen.dart';
import 'package:rentverse_mobile/features/admin/screens/user_management_screen.dart';
import 'package:rentverse_mobile/features/admin/screens/moderation_screen.dart';
import 'package:rentverse_mobile/features/admin/screens/analytics_screen.dart';
import 'package:rentverse_mobile/features/admin/screens/admin_main_wrapper.dart';

final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _adminShellNavigatorKey = GlobalKey<NavigatorState>();

late ProviderContainer _rootContainer;

// --- GOROUTER CONFIGURATION ---
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
    
    // TENANT SHELL ROUTE
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => TenantMainWrapper(child: child),
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

        // 🚨 FIX: Property Detail now matches /tenant/property/:id
        GoRoute(
          path: '/tenant/property/:id',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return PropertyDetailScreen(propertyId: id);
          },
        ),
      ],
    ),
    
    // ADMIN SHELL ROUTE
    ShellRoute(
      navigatorKey: _adminShellNavigatorKey, 
      builder: (context, state, child) => AdminMainWrapper(child: child),
      routes: [
        GoRoute(
          path: '/admin',
          parentNavigatorKey: _adminShellNavigatorKey,
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/admin/users', 
          parentNavigatorKey: _adminShellNavigatorKey,
          builder: (context, state) => const UserManagementScreen(),
        ),
        GoRoute(
          path: '/admin/moderation', 
          parentNavigatorKey: _adminShellNavigatorKey,
          builder: (context, state) => const ModerationScreen(),
        ),
        GoRoute(
          path: '/admin/analytics', 
          parentNavigatorKey: _adminShellNavigatorKey,
          builder: (context, state) => const AnalyticsScreen(),
        ),
      ],
    ),

    // TENANT APPLICATION FLOW (Updated to use IDs)
    GoRoute(
      path: '/apply/:id', 
      builder: (context, state) => ApplicationStepOneScreen(
        propertyId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/apply/financial/:id', 
      builder: (context, state) => ApplicationStepTwoScreen(
        propertyId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/apply/residence/:id', 
      builder: (context, state) => ApplicationStepThreeScreen(
        propertyId: state.pathParameters['id']!,
      ),
    ),

    // USER MANAGEMENT
    GoRoute(path: '/profile', builder: (context, state) => const ProfileEditScreen()),
    GoRoute(path: '/change-password', builder: (context, state) => const PasswordChangeScreen()),

    // LANDLORD ROUTES
    GoRoute(path: '/landlord', builder: (context, state) => const LandlordHomeScreen()),
    GoRoute(path: '/landlord/add-property', builder: (context, state) => const AddPropertyStepOneScreen()),
    GoRoute(path: '/landlord/add-property/details', builder: (context, state) => const AddPropertyStepTwoScreen()),
    GoRoute(path: '/landlord/add-property/description', builder: (context, state) => const AddPropertyStepThreeScreen()),
    GoRoute(
      path: '/landlord/edit-property/:id', 
      builder: (context, state) => EditPropertyScreen(
        propertyId: state.pathParameters['id']!,
      ),
    ),
    GoRoute(
      path: '/landlord/applications',
      builder: (context, state) => const LandlordApplicationsScreen(),
    ),
    GoRoute(
  path: '/landlord/application-detail',
  builder: (context, state) {
    final app = state.extra as RentalApplication;
    return ApplicationDetailScreen(application: app);
  },
),
  ],
  
  // GLOBAL REDIRECT LOGIC
  redirect: (context, state) {
    final ref = _rootContainer;
    final isAuthenticated = ref.read(isAuthenticatedProvider);
    final user = ref.read(authNotifierProvider);
    final isLoggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/register';
    
    final isLandlord = user?.role == 'landlord';
    final isAdmin = user?.role == 'admin'; 

    if (!isAuthenticated && !isLoggingIn) return '/login';

    if (isAuthenticated && isLoggingIn) {
      if (isAdmin) return '/admin'; 
      if (isLandlord) return '/landlord'; 
      return '/'; 
    }

    return null;
  },
  
  refreshListenable: AuthRedirectListenable(
    _rootContainer.read(authNotifierProvider.notifier),
  ),
);

// --- AUTH LISTENERS ---
class AuthRedirectListenable extends ChangeNotifier {
  final AuthNotifier _notifier;
  late VoidCallback _disposeListener; 

  AuthRedirectListenable(this._notifier) {
    _disposeListener = _notifier.addListener((state) {
      notifyListeners();
    }, fireImmediately: true); 
  }

  @override
  void dispose() {
    _disposeListener(); 
    super.dispose();
  }
}

void main() {
  _rootContainer = ProviderContainer();
  runApp(
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