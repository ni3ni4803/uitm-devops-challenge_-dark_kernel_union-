import 'package:flutter/material.dart';
import 'package:rentverse_mobile/features/tenant/models/rental_application.dart';

class ApplicationDetailScreen extends StatelessWidget {
  final RentalApplication application;

  const ApplicationDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review: ${application.fullName}'),
        // Use default back button provided by GoRouter
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
                    onPressed: () => _handleAction(context, 'Approved'),
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
                    onPressed: () => _handleAction(context, 'Rejected'),
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
        // 🚨 FIX: Changed 'separated' to 'spaceBetween'
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

  void _handleAction(BuildContext context, String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Application $status')),
    );
    Navigator.pop(context);
  }
}