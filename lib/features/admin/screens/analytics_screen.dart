import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/state/analytics_notifier.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  // Helper method to trigger the initial data fetch (equivalent to initState)
  void _initializeData(WidgetRef ref, AnalyticsState state, AnalyticsNotifier notifier) {
    if (state.data == null && !state.isLoading) {
      // Use Future.microtask to call the async method after the build phase completes
      Future.microtask(() => notifier.fetchAnalyticsData());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsNotifierProvider);
    final notifier = ref.read(analyticsNotifierProvider.notifier);
    
    // 🚨 NEW: Call the initialization logic
    _initializeData(ref, state, notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Analytics'),
        actions: [
          IconButton(
            icon: state.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : notifier.fetchAnalyticsData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _buildBody(context, state, notifier),
    );
  }

  Widget _buildBody(BuildContext context, AnalyticsState state, AnalyticsNotifier notifier) {
    if (state.isLoading && state.data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text('Error: ${state.errorMessage}'),
      );
    }
    
    final data = state.data;
    if (data == null) {
      return const Center(child: Text('No analytics data available.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Financial Overview',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Revenue Chart Placeholder
          Container(
            height: 250,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
              borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text(
                'Monthly Revenue Chart Placeholder\nLast Month: \$${data.revenueData.last.amount.toStringAsFixed(2)}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueGrey),
              ),
            ),
          ),
          
          const SizedBox(height: 30),
          const Text(
            'User & Property Insights',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // User Growth Chart Placeholder
          Container(
            height: 250,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8)
            ),
            child: Center(
              child: Text(
                'User Growth Over Time Chart Placeholder\nTotal Users Added Last Quarter: ${data.userGrowthData.last.count}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.green),
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Property Distribution and Bounce Rate Card
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Distribution
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Property Distribution', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        ...data.propertyDistribution.map((item) => Text('${item.type}: ${item.count} listings')),
                      ],
                    ),
                  ),
                ),
              ),

              // Bounce Rate
              Expanded(
                child: Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Engagement', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          'Bounce Rate: ${data.bounceRatePercentage}%',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: data.bounceRatePercentage > 50 ? Colors.red : Colors.green,
                          ),
                        ),
                        const Text('Target: < 50%'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
