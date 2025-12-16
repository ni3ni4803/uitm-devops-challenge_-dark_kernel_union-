import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationStepTwoScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationStepTwoScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationStepTwoScreen> createState() =>
      _ApplicationStepTwoScreenState();
}

class _ApplicationStepTwoScreenState
    extends ConsumerState<ApplicationStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  // Local controllers
  final _incomeController = TextEditingController();
  final _employerController = TextEditingController();
  final _durationController = TextEditingController();

  // We use the same provider created in Step 1
  late final applicationProvider = applicationNotifierProvider(widget.propertyId);

  @override
  void initState() {
    super.initState();
    // Load existing data from the notifier
    final currentApp = ref.read(applicationProvider);
    _incomeController.text = currentApp.monthlyIncome.toString();
    _employerController.text = currentApp.employerName;
    _durationController.text = currentApp.employmentDuration;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      final currentApp = ref.read(applicationProvider);

      // Create a copy with updated data
      final updatedApp = currentApp.copyWith(
        monthlyIncome: double.tryParse(_incomeController.text.trim()) ?? 0.0,
        employerName: _employerController.text.trim(),
        employmentDuration: _durationController.text.trim(),
      );

      // Update the Riverpod state
      ref.read(applicationProvider.notifier).updateApplication(updatedApp);

      // Navigate to the next step (Residence History)
      context.go('/apply/residence/${widget.propertyId}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application: Financial Info (2/3)'),
        // Back button returns to Step 1
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/apply/${widget.propertyId}'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _incomeController,
                decoration: const InputDecoration(labelText: 'Monthly Income (\$)', helperText: 'Gross income before tax'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (double.tryParse(value) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _employerController,
                decoration: const InputDecoration(labelText: 'Employer Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Employment Duration (Years/Months)'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Next: Residence History'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _employerController.dispose();
    _durationController.dispose();
    super.dispose();
  }
}