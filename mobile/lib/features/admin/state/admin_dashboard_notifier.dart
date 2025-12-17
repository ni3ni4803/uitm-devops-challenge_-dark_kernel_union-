import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/models/analytics_data.dart';

// 1. The State Class
class AdminDashboardState {
  final AnalyticsData? stats;
  final bool isLoading;
  final String? errorMessage;

  const AdminDashboardState({
    this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  AdminDashboardState copyWith({
    AnalyticsData? stats,
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

// 2. The Notifier
class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  AdminDashboardNotifier() : super(const AdminDashboardState());

  Future<void> fetchDashboardStats() async {
    // Prevent multiple simultaneous requests
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      // 🚨 MODIFIED: Providing all REQUIRED summary fields and mock chart data
      final mockAnalytics = AnalyticsData(
        // Summary Stats (Required by your StatCards in the UI)
        totalProperties: 1250,
        pendingApprovals: 42,
        activeTenants: 890,
        activeLandlords: 360,

        // Chart Data (Required by your updated AnalyticsData model)
        revenueData: [
          MonthlyRevenue('Jan', 5000),
          MonthlyRevenue('Feb', 7500),
          MonthlyRevenue('Mar', 6200),
        ],
        userGrowthData: [
          UserGrowth('Jan', 100),
          UserGrowth('Feb', 150),
          UserGrowth('Mar', 210),
        ],
        propertyDistribution: [
          PropertyDistribution('Apartment', 500),
          PropertyDistribution('House', 400),
          PropertyDistribution('Condo', 350),
        ],
        bounceRatePercentage: 12,
      );

      state = state.copyWith(stats: mockAnalytics, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to load dashboard: $e',
        isLoading: false,
      );
    }
  }
}

// 3. The Provider
final adminDashboardNotifierProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier();
});