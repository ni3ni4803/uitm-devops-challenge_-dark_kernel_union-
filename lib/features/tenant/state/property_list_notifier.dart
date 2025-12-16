import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/data/repositories/property_repository.dart';
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart'; // <-- New Import

final propertyListNotifierProvider = 
    AsyncNotifierProvider<PropertyListNotifier, List<Property>>(
        PropertyListNotifier.new);

class PropertyListNotifier extends AsyncNotifier<List<Property>> {

  @override
  Future<List<Property>> build() async {
    // 1. WATCH the filter state. This makes this provider automatically rebuild
    //    whenever the PropertyFilter object changes.
    final currentFilter = ref.watch(filterNotifierProvider); 

    // 2. Read the Repository Provider
    final repository = ref.watch(propertyRepositoryProvider);
    
    // 3. Pass the filter to the repository method
    return repository.getProperties(currentFilter); // <-- Updated Call
  }

  // Future methods for later use (e.g., refreshing or adding filters)
  Future<void> refreshProperties() async {
    // This method forces the AsyncNotifier to re-run the build() method.
    state = const AsyncLoading(); // Set state to loading explicitly
    
    // Rerun the build method and update the state automatically
    state = await AsyncValue.guard(() => build()); 
  }
}