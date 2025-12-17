import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/models/property_pending.dart';

// State definition
class ModerationState {
  final List<PropertyPending> pendingProperties;
  final bool isLoading;
  final String? errorMessage;

  ModerationState({
    this.pendingProperties = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ModerationState copyWith({
    List<PropertyPending>? pendingProperties,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ModerationState(
      pendingProperties: pendingProperties ?? this.pendingProperties,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Note: Set to null if not explicitly provided
    );
  }
}

// State Notifier
class ModerationNotifier extends StateNotifier<ModerationState> {
  ModerationNotifier() : super(ModerationState()) {
    fetchPendingProperties(); // Fetch initial data
  }

  // --- API Simulation Data ---
  // NOTE: Using a modifiable list to simulate backend changes
  final List<PropertyPending> _dummyPendingProperties = [
    PropertyPending(
      id: 'p005', 
      title: 'Luxury Condo Near Transit', 
      landlordName: 'Jane Doe', 
      rentPrice: 2200.00, 
      submissionDate: DateTime(2025, 12, 16, 10, 30)
    ),
    PropertyPending(
      id: 'p006', 
      title: 'Cozy 2-Bedroom Apartment', 
      landlordName: 'Mark Smith', 
      rentPrice: 1550.00, 
      submissionDate: DateTime(2025, 12, 16, 15, 05)
    ),
    PropertyPending(
      id: 'p007', 
      title: 'Large Family House with Yard', 
      landlordName: 'Estate Mgmt Inc.', 
      rentPrice: 3100.00, 
      submissionDate: DateTime(2025, 12, 17, 8, 45)
    ),
  ];

  // 🚨 NEW METHOD: Refresh data without showing a full screen spinner
  Future<void> refreshPendingProperties() async {
    state = state.copyWith(errorMessage: null); // Clear old errors
    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Shorter refresh delay
      state = state.copyWith(pendingProperties: List.from(_dummyPendingProperties));
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to refresh pending properties.');
    }
  }

  // Fetch pending properties from the server (used for initial load)
  Future<void> fetchPendingProperties() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await Future.delayed(const Duration(seconds: 1)); 
      
      // Use List.from to ensure immutability is respected
      state = state.copyWith(pendingProperties: List.from(_dummyPendingProperties), isLoading: false);
      
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to fetch pending properties.');
    }
  }

  // Handle Approval/Rejection
  Future<void> updatePropertyStatus(String propertyId, String newStatus) async {
    // 1. Store the original property for rollback
    final propertyToUpdate = state.pendingProperties.firstWhere((p) => p.id == propertyId);
    
    // 2. Optimistic UI Update: Temporarily remove the property from the list
    final updatedList = state.pendingProperties.where((p) => p.id != propertyId).toList();
    state = state.copyWith(pendingProperties: updatedList);

    try {
      // 3. Simulate API call
      await Future.delayed(const Duration(milliseconds: 700));

      // 4. Update the internal mock source to reflect successful change on "backend"
      // (The property should no longer appear in future fetches)
      _dummyPendingProperties.removeWhere((p) => p.id == propertyId);
      
      print('Property $propertyId $newStatus');

    } catch (e) {
      // 5. Failure: Revert the UI state
      state = state.copyWith(
        errorMessage: 'Failed to update property status. Please try refreshing.',
        // Add the property back to the list
        pendingProperties: [...updatedList, propertyToUpdate], 
      );
      // Revert the dummy list as well if necessary, but here we just rely on the next fetch
    }
  }
}

// Riverpod provider
final moderationNotifierProvider = 
    StateNotifierProvider<ModerationNotifier, ModerationState>(
  (ref) => ModerationNotifier(),
);

