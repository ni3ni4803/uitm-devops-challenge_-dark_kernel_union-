import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_notifier.dart';

class AddPropertyStepOneScreen extends ConsumerStatefulWidget {
  const AddPropertyStepOneScreen({super.key});

  @override
  ConsumerState<AddPropertyStepOneScreen> createState() =>
      _AddPropertyStepOneScreenState();
}

class _AddPropertyStepOneScreenState extends ConsumerState<AddPropertyStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  // Use 'late' only, as they are initialized in initState
  late TextEditingController _titleController; 
  late TextEditingController _addressController;
  late TextEditingController _rentController;

  @override
  void initState() {
    super.initState();
    
    final currentState = ref.read(propertyCreationNotifierProvider);
    
    // === CRITICAL FIX: The method name in the Notifier is resetDraft() ===
    // Only reset the draft if we are starting a *new* property (ID is null).
    // If the user lands here via the 'Add Property' button, the state should be clean.
    if (currentState.id == null && currentState.title.isNotEmpty) {
      // This ensures if they force-navigate back to step 1 from outside the flow, the form is fresh.
      // However, usually, reset is only called upon successful submission or manual close.
      // We will remove this line to allow persistent navigation back-and-forth between the steps.
      // ref.read(propertyCreationNotifierProvider.notifier).resetDraft(); 
    }
    
    // Initialize controllers with current state data from the notifier
    final state = ref.read(propertyCreationNotifierProvider); 
    _titleController = TextEditingController(text: state.title);
    _addressController = TextEditingController(text: state.address);
    // Convert double rent to string for the controller
    _rentController = TextEditingController(
      // Check if monthlyRent is defined before displaying
      text: state.monthlyRent > 0 ? state.monthlyRent.toString() : '',
    );
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // 1. Update the Riverpod state with current values
      ref.read(propertyCreationNotifierProvider.notifier).updateBasicInfo(
            title: _titleController.text.trim(),
            address: _addressController.text.trim(),
            monthlyRent: double.tryParse(_rentController.text) ?? 0.0,
          );

      // 2. Navigate to the next step
      context.go('/landlord/add-property/details');
    }
  }
  
  // Helper to handle navigation away (Close/Cancel)
  void _handleCancel() {
    final creationState = ref.read(propertyCreationNotifierProvider);
    final notifier = ref.read(propertyCreationNotifierProvider.notifier);

    // If adding a new property, clear the draft state
    if (creationState.id == null) {
        notifier.resetDraft(); // 🚨 Correct method call
        context.go('/landlord');
    } else {
        // If editing, go back to the landlord home (or property detail screen if implemented)
        context.go('/landlord'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. WATCH the state to dynamically update the title
    final creationState = ref.watch(propertyCreationNotifierProvider);
    
    // 2. Determine the title based on the presence of the ID
    final titleText = creationState.id == null 
        ? 'Add New Property (1/3)' 
        : 'Edit Property Listing (1/3)'; 
        
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText), // Use the dynamic title
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _handleCancel, // Use dedicated cancel handler
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Basic Information',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Property Title',
                  hintText: 'e.g., Luxury Downtown Loft',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Full Address',
                  hintText: 'e.g., 123 Main St, Apt 4A',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Address is required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _rentController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monthly Rent',
                  hintText: 'e.g., 1800.00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Must be a valid positive number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Next: Details & Amenities', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // NOTE: Only dispose of controllers if they are local, which they are.
    _titleController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    super.dispose();
  }
}
