import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/data/models/property.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_property_list_notifier.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_notifier.dart';

class EditPropertyScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const EditPropertyScreen({super.key, required this.propertyId});

  @override
  ConsumerState<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends ConsumerState<EditPropertyScreen> {
  
  bool _isSetupComplete = false;
  bool _isError = false;
  // Use RiverpodProviderSubscription to manage the listener lifecycle safely
  late ProviderSubscription _propertySubscription;

  @override
  void initState() {
    super.initState();
    
    // Start listening immediately
    _propertySubscription = ref.listenManual(landlordPropertyNotifierProvider, (previous, next) {
        // If data becomes available and we haven't set up the form yet, proceed
        if (next.hasValue && next.value != null && !_isSetupComplete) {
            _loadAndRedirect(next.value!);
        }
        // If an error occurs, update the UI state
        else if (next.hasError && mounted) {
            setState(() {
                _isError = true;
            });
        }
    });
    
    // Check initial state (if data is already loaded, proceed immediately)
    final initialAsyncValue = ref.read(landlordPropertyNotifierProvider);
    if (initialAsyncValue.hasValue && initialAsyncValue.value != null) {
      _loadAndRedirect(initialAsyncValue.value!);
    }
  }

  @override
  void dispose() {
    // IMPORTANT: Close the manual subscription when the widget is removed
    _propertySubscription.close();
    super.dispose();
  }

  // Helper method to load data into the notifier and navigate away
  void _loadAndRedirect(List<Property> properties) {
    // Prevent multiple redirects if the listener fires again during navigation
    if (_isSetupComplete || !mounted) return;
    
    // 2. Find the property by ID
    Property? propertyToEdit;
    
    // Iterate over the non-nullable list
    for (var p in properties) {
      if (p.id == widget.propertyId) {
        propertyToEdit = p;
        break;
      }
    }

    // 3. Handle property not found
    if (propertyToEdit == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Error: Property ID ${widget.propertyId} not found.')),
      );
      context.go('/landlord');
      return;
    }
    
    // 4. Load data into Notifier and Redirect (safe because we are inside a listener/postFrameCallback)
    // We use addPostFrameCallback to ensure the modification and navigation
    // happens outside of the subscription or build cycle (Riverpod safe).
    WidgetsBinding.instance.addPostFrameCallback((_) {
        // We know propertyToEdit is non-null here due to the check above
        final Property p = propertyToEdit!; 
        final notifier = ref.read(propertyCreationNotifierProvider.notifier);
        
        // Set the ID first (Crucial for the Update logic)
        notifier.setPropertyId(p.id);

        // Load form data - BASIC INFO
        notifier.updateBasicInfo(
          title: p.title,
          address: p.address,
          monthlyRent: p.monthlyRent,
        );
        // Load form data - DETAILS & LOCATION
        notifier.updateDetailsAndLocation(
          bedrooms: p.bedrooms,
          bathrooms: p.bathrooms.toDouble(), 
          amenities: p.amenities,
          latitude: p.latitude,
          longitude: p.longitude,
        );
        // Load form data - DESCRIPTION & MEDIA
        notifier.updateDescriptionAndMedia(
          description: p.description,
          imageUrls: p.imageUrls,
        );
        
        // 5. Navigate to Step 1 of the form, replacing the wrapper screen
        context.go('/landlord/add-property'); 

        // Set flag to prevent further execution in this method
        if (mounted) {
            setState(() {
                _isSetupComplete = true;
            });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch the AsyncValue to show initial loading state
    final propertyListAsync = ref.watch(landlordPropertyNotifierProvider);
    
    // Show spinner if loading or if we haven't successfully redirected yet
    if (propertyListAsync.isLoading || !_isSetupComplete) {
      if (_isError) {
         return Scaffold(
             appBar: AppBar(title: const Text('Error')),
             body: Center(child: Text('Error loading properties: ${propertyListAsync.error}')),
         );
      }
      return const Scaffold(
        appBar: null,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // This path is theoretically unreachable once navigation succeeds.
    return const Scaffold(
        body: Center(child: Text('Redirecting...'))
    );
  }
}

