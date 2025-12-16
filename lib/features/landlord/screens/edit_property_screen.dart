import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/landlord/screens/add_property_step_one_screen.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_property_list_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_notifier.dart';

class EditPropertyScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const EditPropertyScreen({super.key, required this.propertyId});

  @override
  ConsumerState<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends ConsumerState<EditPropertyScreen> {
  bool _isInitialized = false;

  void _initializeEditForm(List<dynamic> properties) {
    if (_isInitialized) return; // Prevent re-initialization

    // 1. Find the property by ID from the list. orElse must return null (Property?)
    final propertyToEdit = properties.firstWhere(
      (p) => p.id == widget.propertyId,
      // CORRECTED orElse: Always returns null if not found.
      orElse: () => null,
    );
    
    // 2. If property is not found, navigate away after this frame.
    if (propertyToEdit == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/landlord');
      });
      return;
    }

    // 3. Load the property data into the PropertyCreationNotifier
    final notifier = ref.read(propertyCreationNotifierProvider.notifier);
    
    // NOTE: propertyToEdit is now guaranteed to be a Property object.
    notifier.updateBasicInfo(
      title: propertyToEdit.title,
      address: propertyToEdit.address,
      monthlyRent: propertyToEdit.monthlyRent,
    );
    notifier.updateDetailsAndLocation(
      bedrooms: propertyToEdit.bedrooms,
      bathrooms: propertyToEdit.bathrooms,
      amenities: propertyToEdit.amenities,
      latitude: propertyToEdit.latitude,
      longitude: propertyToEdit.longitude,
    );
    notifier.updateDescriptionAndMedia(
      description: propertyToEdit.description,
      imageUrls: propertyToEdit.imageUrls,
    );
    
    // 4. Mark as initialized
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the property list. The widget will rebuild when data is loaded.
    final propertyListAsync = ref.watch(landlordPropertyNotifierProvider);

    return propertyListAsync.when(
      loading: () => const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('Error loading data: $e')),
      ),
      data: (properties) {
        // 2. Data is available. Initialize the form state if not already done.
        _initializeEditForm(properties);

        // 3. Only show the form once initialization is complete.
        if (!_isInitialized) {
           return const Scaffold(
            appBar: null,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 4. Initialization successful. Display the Step 1 screen.
        // It will automatically read the pre-filled data from the notifier.
        return const AddPropertyStepOneScreen();
      },
    );
  }
}