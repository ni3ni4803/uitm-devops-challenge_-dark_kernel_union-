import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:rentverse_mobile/features/tenant/models/rental_application.dart'; 
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationStepOneScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationStepOneScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationStepOneScreen> createState() =>
      _ApplicationStepOneScreenState();
}

class _ApplicationStepOneScreenState
    extends ConsumerState<ApplicationStepOneScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Local controllers to capture form input
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();

  // Initialize the state notifier for this specific property ID
  late final applicationProvider = applicationNotifierProvider(widget.propertyId);

  @override
  void initState() {
    super.initState();
    // Load existing data if navigating back from a later step
    final currentApp = ref.read(applicationProvider);
    _fullNameController.text = currentApp.fullName;
    _phoneController.text = currentApp.phone;
    _dobController.text = currentApp.dateOfBirth;
  }
  
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // 1. Get the current application state
      final currentApp = ref.read(applicationProvider);

      // 2. Create a copy with updated data
      final updatedApp = currentApp.copyWith(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
      );

      // 3. Update the Riverpod state
      ref.read(applicationProvider.notifier).updateApplication(updatedApp);

      // 4. Navigate to the next step
      // We will define this route next
      context.go('/apply/financial/${widget.propertyId}'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application: Personal Info (1/3)'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                // In a real app, this would use a DatePicker
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Next: Financial Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }
}