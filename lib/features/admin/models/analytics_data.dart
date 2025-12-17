class MonthlyRevenue {
  final String month;
  final double amount;

  MonthlyRevenue(this.month, this.amount);
}

class UserGrowth {
  final String month;
  final int count;

  UserGrowth(this.month, this.count);
}

class PropertyDistribution {
  final String type; // e.g., 'Apartment', 'House', 'Condo'
  final int count;

  PropertyDistribution(this.type, this.count);
}

class AnalyticsData {
  final List<MonthlyRevenue> revenueData;
  final List<UserGrowth> userGrowthData;
  final List<PropertyDistribution> propertyDistribution;
  final int bounceRatePercentage;

  AnalyticsData({
    required this.revenueData,
    required this.userGrowthData,
    required this.propertyDistribution,
    required this.bounceRatePercentage,
  });
}