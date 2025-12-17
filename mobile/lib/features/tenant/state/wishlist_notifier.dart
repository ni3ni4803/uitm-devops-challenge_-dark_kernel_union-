import 'package:flutter/material.dart'; // Added for debugPrint
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 1. NEW IMPORT: Import the provider that initializes SharedPreferences
import 'package:rentverse_mobile/utils/app_providers.dart'; 

// Key used to store the list of IDs in SharedPreferences
const String _kWishlistKey = 'favorite_property_ids';

// Provider that exposes the current list of favorite property IDs
final wishlistNotifierProvider = 
    NotifierProvider<WishlistNotifier, Set<String>>(WishlistNotifier.new);

class WishlistNotifier extends Notifier<Set<String>> {
  
  // We no longer need to use 'late' or '_initPrefs()'
  // The SharedPreferences instance will be accessed via the provider.

  // The build method initializes the state by watching the SharedPreferences provider.
  @override
  Set<String> build() {
    // 2. WATCH the FutureProvider. This makes the build method wait until the 
    //    SharedPreferences instance is available and returns an AsyncValue.
    final prefsAsyncValue = ref.watch(sharedPreferencesProvider);

    // 3. Handle the loading/error state of the dependency (standard Riverpod pattern)
    return prefsAsyncValue.when(
      loading: () {
        // While loading, return an empty set to prevent errors
        return const {};
      },
      error: (err, stack) {
        // Log the error and still return an empty set
        debugPrint('Error loading SharedPreferences: $err');
        return const {};
      },
      data: (prefs) {
        // 4. Dependency is ready! Load the initial state from SharedPreferences.
        final List<String>? savedList = prefs.getStringList(_kWishlistKey);
        
        // Return the loaded set of IDs, or an empty set if null
        return savedList?.toSet() ?? const {};
      },
    );
  }
  
  // 5. NEW HELPER: Get the initialized SharedPreferences instance safely
  SharedPreferences? get _prefs {
    return ref.read(sharedPreferencesProvider).value;
  }

  // Reads the saved list from SharedPreferences and updates the state.
  // We can remove the old _loadWishlist() as the logic is now in build()
  
  // Writes the current state (Set<String>) back to SharedPreferences.
  Future<void> _saveWishlist(Set<String> newWishlist) async {
    state = newWishlist;
    // 6. Use the safe _prefs getter to save the list
    await _prefs?.setStringList(_kWishlistKey, state.toList());
  }

  // Toggles the favorite status of a property.
  void toggleFavorite(String propertyId) {
    // 7. Prevent execution if SharedPreferences is still loading
    if (_prefs == null) return; 

    final currentFavorites = state;
    final isFavorite = currentFavorites.contains(propertyId);
    
    if (isFavorite) {
      // Remove from favorites
      final newWishlist = {...currentFavorites}..remove(propertyId);
      _saveWishlist(newWishlist);
    } else {
      // Add to favorites
      final newWishlist = {...currentFavorites}..add(propertyId);
      _saveWishlist(newWishlist);
    }
  }

  // Convenience method for UI to check status.
  // This is safe as it only reads the synchronous 'state'
  bool isFavorite(String propertyId) {
    return state.contains(propertyId);
  }
}