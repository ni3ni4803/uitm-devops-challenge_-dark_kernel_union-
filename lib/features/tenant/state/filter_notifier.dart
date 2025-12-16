import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property_filter.dart';

// Provides the current PropertyFilter state
final filterNotifierProvider = NotifierProvider<FilterNotifier, PropertyFilter>(
    FilterNotifier.new);

class FilterNotifier extends Notifier<PropertyFilter> {
  // Initialize with the default filter
  @override
  PropertyFilter build() {
    return const PropertyFilter();
  }

  // Method to update the price range filter
  void updatePriceRange({double? min, double? max}) {
    state = state.copyWith(
      minRent: min ?? state.minRent,
      maxRent: max ?? state.maxRent,
    );
  }
  
  // Method to reset all filters to default
  void resetFilters() {
    state = const PropertyFilter();
  }
}