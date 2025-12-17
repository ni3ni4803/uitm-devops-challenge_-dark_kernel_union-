import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; //
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';
import 'package:rentverse_mobile/features/landlord/state/landlord_applications_notifier.dart'; // Ensure this import path is correct


class ApplicationDetailScreen extends ConsumerWidget { // Changed to ConsumerWidget to access 'ref'
  final RentalApplication application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context, WidgetRef ref) { // Added WidgetRef
    return Scaffold(
      appBar: AppBar(
        title: Text('Review: ${application.fullName}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Personal Information'),
            _buildInfoTile('Email', application.email),
            _buildInfoTile('Phone', application.phone),
            _buildInfoTile('License #', application.driverLicenseNumber),
            _buildInfoTile('DOB', application.dateOfBirth),
            
            const Divider(height: 32),
            _buildSectionHeader('Financial Information'),
            _buildInfoTile('Monthly Income', '\$${application.currentMonthlyIncome}'),
            _buildInfoTile('Employer', application.employerName),
            _buildInfoTile('Duration', application.employmentDuration),
            
            const Divider(height: 32),
            _buildSectionHeader('Residence History'),
            _buildInfoTile('Current Address', application.currentAddress),
            _buildInfoTile('Landlord', application.currentLandlordName),
            _buildInfoTile('Landlord Phone', application.currentLandlordPhone),
            
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleApprove(context, ref), // Updated handler
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Approve'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleReject(context, ref), // Updated handler
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // --- Functional Handlers ---

  Future<void> _handleApprove(BuildContext context, WidgetRef ref) async {
    // Call the approve method in your notifier
    await ref.read(landlordApplicationsProvider.notifier).approveApplication(application.id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application Approved'), backgroundColor: Colors.green),
      );
      Navigator.pop(context); // Go back to the list
    }
  }

  Future<void> _handleReject(BuildContext context, WidgetRef ref) async {
    // Call the reject method in your notifier
    await ref.read(landlordApplicationsProvider.notifier).rejectApplication(application.id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application Rejected'), backgroundColor: Colors.red),
      );
      Navigator.pop(context); // Go back to the list
    }
  }

  // --- UI Helper Widgets ---

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title, 
        style: const TextStyle(
          fontSize: 18, 
          fontWeight: FontWeight.bold, 
          color: Colors.blue
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:', 
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)
          ),
          Text(
            value.isEmpty ? 'N/A' : value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}