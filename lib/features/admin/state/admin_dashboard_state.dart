//import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <--- NEW: Import Riverpod

// ----------------------------------------------------
// 🚨 FIX 1: Define the Riverpod Provider
// This must be defined globally in this file for your screen to access it.
// ----------------------------------------------------
final adminDashboardNotifierProvider = 
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier();
});


// ----------------------------------------------------
// 🚨 FIX 2: Refactor State Class to Riverpod Notifier
// It must now be a StateNotifier, not a ChangeNotifier.
// ----------------------------------------------------
// Define the data class first (or import it from a separate model file)
class DashboardStats {
  final int totalProperties;
  final int pendingApprovals;
  final int activeTenants;
  final int activeLandlords;

  DashboardStats({
    required this.totalProperties,
    required this.pendingApprovals,
    required this.activeTenants,
    required this.activeLandlords,
  });
}

// Define the State class (what the provider will hold at any time)
class AdminDashboardState {
  final DashboardStats? stats;
  final bool isLoading;
  final String? errorMessage;

  AdminDashboardState({
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  // Helper method for updating state
  AdminDashboardState copyWith({
    DashboardStats? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AdminDashboardState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}


// Define the Notifier (replaces ChangeNotifier)
class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  // Initialize the state in the constructor
  AdminDashboardNotifier() : super(AdminDashboardState());


  // 1. Logic to fetch the dashboard data
  Future<void> fetchDashboardStats() async {
    // Set state to loading
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // --- Replace this with your actual API call ---
      await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
      
      // Simulate successful data fetch
      final DashboardStats newStats = DashboardStats(
        totalProperties: 1250,
        pendingApprovals: 42,
        activeTenants: 890,
        activeLandlords: 360,
      );
      // ----------------------------------------------

      // Set state to success
      state = state.copyWith(stats: newStats, isLoading: false);

    } catch (e) {
      // Set state to error
      state = state.copyWith(
        errorMessage: 'Failed to load dashboard data: $e', 
        isLoading: false
      );
    }
  }
}