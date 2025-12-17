/*import 'package:flutter_riverpod/flutter_riverpod.dart';

// ----------------------------------------------------
// 1. DATA MODEL (Matches your Screen's expectation)
// ----------------------------------------------------
class DashboardStats {
  final int totalProperties;
  final int pendingApprovals;
  final int activeTenants;
  final int activeLandlords;

  const DashboardStats({
    required this.totalProperties,
    required this.pendingApprovals,
    required this.activeTenants,
    required this.activeLandlords,
  });
}

// ----------------------------------------------------
// 2. STATE CLASS (Immutable)
// ----------------------------------------------------
class AdminDashboardState {
  final DashboardStats? stats;
  final bool isLoading;
  final String? errorMessage;

  const AdminDashboardState({
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

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

// ----------------------------------------------------
// 3. NOTIFIER (Business Logic)
// ----------------------------------------------------
class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  AdminDashboardNotifier() : super(const AdminDashboardState());

  Future<void> fetchDashboardStats() async {
    // Avoid double-fetching if already loading
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      // Mock Data (Replace with your actual API/Firebase call later)
      const newStats = DashboardStats(
        totalProperties: 1250,
        pendingApprovals: 42,
        activeTenants: 890,
        activeLandlords: 360,
      );

      state = state.copyWith(stats: newStats, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load dashboard data: $e',
        isLoading: false,
      );
    }
  }
}

// ----------------------------------------------------
// 4. THE PROVIDER
// ----------------------------------------------------
final adminDashboardNotifierProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier();
});*/