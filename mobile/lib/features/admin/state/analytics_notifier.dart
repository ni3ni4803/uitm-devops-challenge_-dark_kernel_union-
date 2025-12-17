import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:rentverse_mobile/features/admin/models/analytics_data.dart'; // Commented out to define models here

// =========================================================
// 🚨 NEW: Data Models (Assuming these were in analytics_data.dart)
// =========================================================

// Model for Monthly Revenue Chart
class MonthlyRevenue {
  final String month;
  final double amount;
  const MonthlyRevenue(this.month, this.amount);
}

// Model for Quarterly User Growth Chart
class UserGrowth {
  final String quarter;
  final int count;
  const UserGrowth(this.quarter, this.count);
}

// Model for Property Distribution Chart (Pie/Bar)
class PropertyDistribution {
  final String type;
  final int count;
  const PropertyDistribution(this.type, this.count);
}

// Main container for all analytics data
class AnalyticsData {
  final List<MonthlyRevenue> revenueData;
  final List<UserGrowth> userGrowthData;
  final List<PropertyDistribution> propertyDistribution;
  final int bounceRatePercentage; // Example KPI

  AnalyticsData({
    required this.revenueData,
    required this.userGrowthData,
    required this.propertyDistribution,
    required this.bounceRatePercentage,
  });
}

// =========================================================
// State definition and Notifier (Unchanged/Refined)
// =========================================================

class AnalyticsState {
  final AnalyticsData? data;
  final bool isLoading;
  final String? errorMessage;

  AnalyticsState({
    this.data,
    this.isLoading = false,
    this.errorMessage,
  });

  AnalyticsState copyWith({
    AnalyticsData? data,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AnalyticsState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// State Notifier
class AnalyticsNotifier extends StateNotifier<AnalyticsState> {
  AnalyticsNotifier() : super(AnalyticsState()) {
    fetchAnalyticsData(); // Fetch data immediately on initialization
  }

  Future<void> fetchAnalyticsData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API delay
      
      // Simulate API response with complex data
      final fetchedData = AnalyticsData(
        revenueData: const [
          MonthlyRevenue('Jan', 15000), MonthlyRevenue('Feb', 18000), 
          MonthlyRevenue('Mar', 25000), MonthlyRevenue('Apr', 22000)
        ],
        userGrowthData: const [
          UserGrowth('Q1', 120), UserGrowth('Q2', 250), 
          UserGrowth('Q3', 400), UserGrowth('Q4', 650)
        ],
        propertyDistribution: const [
          PropertyDistribution('Apartment', 600),
          PropertyDistribution('House', 300),
          PropertyDistribution('Condo', 350),
        ],
        bounceRatePercentage: 35,
      );

      state = state.copyWith(data: fetchedData, isLoading: false, errorMessage: null); // 🚨 Ensure errorMessage is reset to null
      
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load analytics data.');
    }
  }
}

// Riverpod provider
final analyticsNotifierProvider = 
    StateNotifierProvider<AnalyticsNotifier, AnalyticsState>(
  (ref) => AnalyticsNotifier(),
);
