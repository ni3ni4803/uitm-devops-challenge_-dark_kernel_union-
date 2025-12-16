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
  late final TextEditingController _titleController;
  late final TextEditingController _addressController;
  late final TextEditingController _rentController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current state data from the notifier
    final state = ref.read(propertyCreationNotifierProvider);
    _titleController = TextEditingController(text: state.title);
    _addressController = TextEditingController(text: state.address);
    // Convert double rent to string for the controller
    _rentController = TextEditingController(
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
      // We will define this route in the next step
      context.go('/landlord/add-property/details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Property (1/3)'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // OPTIONAL: Reset form state when closing
            ref.read(propertyCreationNotifierProvider.notifier).resetForm();
            context.go('/landlord'); // Close and return to dashboard
          },
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
    _titleController.dispose();
    _addressController.dispose();
    _rentController.dispose();
    super.dispose();
  }
}