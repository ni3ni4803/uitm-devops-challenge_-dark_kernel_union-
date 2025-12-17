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

  late final TextEditingController _addressController;
  late final TextEditingController _landlordNameController;
  late final TextEditingController _landlordPhoneController;
  
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(applicationNotifierProvider(widget.propertyId));

    _addressController = TextEditingController(text: state.currentAddress);
    _landlordNameController = TextEditingController(text: state.currentLandlordName);
    _landlordPhoneController = TextEditingController(text: state.currentLandlordPhone);
  }

  @override
  void dispose() {
    _addressController.dispose();
    _landlordNameController.dispose();
    _landlordPhoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      final notifier = ref.read(applicationNotifierProvider(widget.propertyId).notifier);

      // 1. Save current residence data to state
      notifier.updateResidenceHistory(
        currentAddress: _addressController.text.trim(),
        currentLandlordName: _landlordNameController.text.trim(),
        currentLandlordPhone: _landlordPhoneController.text.trim(),
      );

      // 2. Trigger final submission logic
      final success = await notifier.submitApplication();

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back to the main tenant dashboard
        context.go('/tenant');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Submission failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleBack() {
    context.go('/apply/financial/${widget.propertyId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application (3/3): Residence'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Current Residence History',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Current Home Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _landlordNameController,
                decoration: const InputDecoration(
                  labelText: 'Current Landlord Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _landlordPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Landlord Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) =>
                    value == null || value.length < 8
                        ? 'Valid phone required'
                        : null,
              ),

              const SizedBox(height: 40),

              if (_isSubmitting)
                const Center(child: CircularProgressIndicator())
              else
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleBack,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text(
                          'Submit Final',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}