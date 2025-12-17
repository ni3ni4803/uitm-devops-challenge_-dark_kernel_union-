import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationReviewScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationReviewScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationReviewScreen> createState() =>
      _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState extends ConsumerState<ApplicationReviewScreen> {
  bool _isLoading = false;

  // === Helper function to build review rows ===
  Widget _buildReviewField(
      String title, String value, VoidCallback onEditPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
            onPressed: onEditPressed,
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
  if (_isLoading) return;

  setState(() {
    _isLoading = true;
  });

  // 🔑 Delay provider update until after build is complete
  final success = await Future.microtask(() {
    return ref
        .read(applicationNotifierProvider(widget.propertyId).notifier)
        .submitApplication();
  });

  if (!mounted) return;

  setState(() {
    _isLoading = false;
  });

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Application Submitted Successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Navigate AFTER state update is fully done
    context.go('/');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Submission failed. Please try again.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    // Watch the application state to display the current data
    final applicationData = ref.watch(applicationNotifierProvider(widget.propertyId));

    if (applicationData.isSubmitted) {
      return Scaffold(
        appBar: AppBar(title: const Text('Application Complete')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'Your application for Property ID ${widget.propertyId} has been submitted.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application (4/4): Review & Submit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Review Your Application',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),

            // --- Section 1: Personal Info ---
            const Text('1. Personal Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            _buildReviewField('Full Name', applicationData.fullName,
                () => context.go('/apply/${widget.propertyId}')),
            _buildReviewField('Email', applicationData.email,
                () => context.go('/apply/${widget.propertyId}')),
            _buildReviewField('Phone', applicationData.phone,
                () => context.go('/apply/${widget.propertyId}')),
            _buildReviewField('License/ID', applicationData.driverLicenseNumber,
                () => context.go('/apply/${widget.propertyId}')),
            const Divider(),

            // --- Section 2: Financial Info ---
            const Text('2. Financial Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            _buildReviewField(
                'Monthly Income',
                '\$${applicationData.currentMonthlyIncome.toStringAsFixed(2)}',
                () => context.go('/apply/financial/${widget.propertyId}')),
            _buildReviewField('Employer Name', applicationData.employerName,
                () => context.go('/apply/financial/${widget.propertyId}')),
            _buildReviewField('Employer Phone', applicationData.employerPhone,
                () => context.go('/apply/financial/${widget.propertyId}')),
            const Divider(),

            // --- Section 3: Residence History ---
            const Text('3. Residence History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            _buildReviewField('Current Address', applicationData.currentAddress,
                () => context.go('/apply/residence/${widget.propertyId}')),
            _buildReviewField('Landlord Name', applicationData.currentLandlordName,
                () => context.go('/apply/residence/${widget.propertyId}')),
            _buildReviewField('Landlord Contact', applicationData.currentLandlordPhone,
                () => context.go('/apply/residence/${widget.propertyId}')),
            const Divider(),

            const SizedBox(height: 40),

            // --- Submit Button ---
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: Colors.blue[700],
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : const Text('Confirm & Submit Application',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}