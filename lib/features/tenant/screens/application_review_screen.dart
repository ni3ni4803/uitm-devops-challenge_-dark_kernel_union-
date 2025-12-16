import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
//import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationReviewScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationReviewScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationReviewScreen> createState() =>
      _ApplicationReviewScreenState();
}

class _ApplicationReviewScreenState
    extends ConsumerState<ApplicationReviewScreen> {
  bool _isSubmitting = false;

  // We use the same provider created in Step 1
  late final applicationProvider = applicationNotifierProvider(widget.propertyId);

  Future<void> _handleSubmit() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(applicationProvider.notifier).submitApplication();
      
      // On success, show confirmation and navigate back to the listings home screen
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application Submitted Successfully!')),
        );
        // Clear the state and navigate to the main listings page
        context.go('/'); 
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submission failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  
  // Helper widget to display a single review field
  Widget _buildReviewField(String label, String value, VoidCallback onEdit) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value.isEmpty ? 'Not Provided' : value),
      trailing: IconButton(
        icon: const Icon(Icons.edit, size: 18),
        onPressed: onEdit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to get the final collected data
    final applicationData = ref.watch(applicationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Review & Submit'),
        // Back button returns to Step 3
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/apply/residence/${widget.propertyId}'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Final Check: Please review your information before submitting.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(height: 30),

            // === 1. Personal Info Section ===
            Text('Personal Information', style: Theme.of(context).textTheme.headlineSmall),
            _buildReviewField('Full Name', applicationData.fullName, () => context.go('/apply/${widget.propertyId}')),
            _buildReviewField('Phone', applicationData.phone, () => context.go('/apply/${widget.propertyId}')),
            _buildReviewField('Date of Birth', applicationData.dateOfBirth, () => context.go('/apply/${widget.propertyId}')),
            const Divider(),

            // === 2. Financial Info Section ===
            Text('Financial Information', style: Theme.of(context).textTheme.headlineSmall),
            _buildReviewField('Monthly Income', '\$${applicationData.monthlyIncome.toStringAsFixed(2)}', () => context.go('/apply/financial/${widget.propertyId}')),
            _buildReviewField('Employer', applicationData.employerName, () => context.go('/apply/financial/${widget.propertyId}')),
            _buildReviewField('Employment Duration', applicationData.employmentDuration, () => context.go('/apply/financial/${widget.propertyId}')),
            const Divider(),

            // === 3. Residence History Section ===
            Text('Residence History', style: Theme.of(context).textTheme.headlineSmall),
            _buildReviewField('Current Address', applicationData.currentAddress, () => context.go('/apply/residence/${widget.propertyId}')),
            _buildReviewField('Landlord Contact', applicationData.currentLandlordContact, () => context.go('/apply/residence/${widget.propertyId}')),
            const Divider(height: 50),

            // Terms and Conditions Placeholder (Important for real apps)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "By clicking 'Submit Application', I certify that the information provided is true and accurate.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            
            // Submission Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Application', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}