import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/data/repositories/property_repository.dart';
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart';

final propertyListNotifierProvider = 
    AsyncNotifierProvider<PropertyListNotifier, List<Property>>(
        PropertyListNotifier.new);

class PropertyListNotifier extends AsyncNotifier<List<Property>> {

  @override
  Future<List<Property>> build() async {
    // 1. WATCH the filter state. 
    // This is the "magic" line: whenever FilterNotifier updates, 
    // this build() method triggers automatically.
    final currentFilter = ref.watch(filterNotifierProvider); 

    // 2. Access the repository
    final repository = ref.watch(propertyRepositoryProvider);
    
    // 3. Fetch properties from the repository using the filter object.
    // This ensures filtering happens at the Data/API layer (recommended).
    return await repository.getProperties(currentFilter);
  }

  // Method to manually refresh (e.g., Pull-to-refresh)
  Future<void> refreshProperties() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build()); 
  }
}