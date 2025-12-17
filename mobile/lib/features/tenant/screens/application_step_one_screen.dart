import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationStepOneScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationStepOneScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationStepOneScreen> createState() => _ApplicationStepOneScreenState();
}

class _ApplicationStepOneScreenState extends ConsumerState<ApplicationStepOneScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _licenseController;
  late final TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(applicationNotifierProvider(widget.propertyId));

    _nameController = TextEditingController(text: state.fullName);
    _emailController = TextEditingController(text: state.email);
    _phoneController = TextEditingController(text: state.phone);
    _licenseController = TextEditingController(text: state.driverLicenseNumber);
    _dobController = TextEditingController(text: state.dateOfBirth);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _licenseController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // 1. Save data to the Notifier
      ref.read(applicationNotifierProvider(widget.propertyId).notifier).updatePersonalInfo(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            driverLicenseNumber: _licenseController.text.trim(),
            dateOfBirth: _dobController.text.trim(),
          );

      // 2. FIXED: Navigation path now matches the updated GoRouter config in main.dart
      // We use the full path: /tenant/apply/financial/:id
      context.push('/tenant/apply/financial/${widget.propertyId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application (1/3): Personal Info'),
        // Explicit back button to ensure user returns to Property Details
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Progress Indicator for better UX
              const LinearProgressIndicator(value: 0.33),
              const SizedBox(height: 24),
              
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email Address', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _licenseController,
                decoration: const InputDecoration(labelText: 'Driver License Number', border: OutlineInputBorder()),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true, // Prevents manual typing errors
                onTap: () async {
                  // Optional: Add a Date Picker here for better UX
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
                    firstDate: DateTime(1920),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _dobController.text = pickedDate.toString().split(' ').first;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  hintText: 'Select Date',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Next: Financial Info'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}