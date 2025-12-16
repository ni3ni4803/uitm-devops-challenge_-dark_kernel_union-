import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationStepThreeScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationStepThreeScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationStepThreeScreen> createState() =>
      _ApplicationStepThreeScreenState();
}

class _ApplicationStepThreeScreenState
    extends ConsumerState<ApplicationStepThreeScreen> {
  final _formKey = GlobalKey<FormState>();

  // Local controllers
  final _addressController = TextEditingController();
  final _landlordController = TextEditingController();

  // We use the same provider created in Step 1
  late final applicationProvider = applicationNotifierProvider(widget.propertyId);

  @override
  void initState() {
    super.initState();
    // Load existing data from the notifier
    final currentApp = ref.read(applicationProvider);
    _addressController.text = currentApp.currentAddress;
    _landlordController.text = currentApp.currentLandlordContact;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final currentApp = ref.read(applicationProvider);

      // Create a copy with updated data
      final updatedApp = currentApp.copyWith(
        currentAddress: _addressController.text.trim(),
        currentLandlordContact: _landlordController.text.trim(),
      );

      // 3. Update the Riverpod state
      ref.read(applicationProvider.notifier).updateApplication(updatedApp);

      // 4. Navigate to the final Review step
      context.go('/apply/review/${widget.propertyId}'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application: Residence History (3/3)'),
        // Back button returns to Step 2
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/apply/financial/${widget.propertyId}'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Current Address'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _landlordController,
                decoration: const InputDecoration(labelText: 'Current Landlord/Manager Contact'),
                keyboardType: TextInputType.phone, // Assuming a phone number or email
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Next: Review & Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _landlordController.dispose();
    super.dispose();
  }
}