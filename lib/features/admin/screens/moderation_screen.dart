import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/admin/models/property_pending.dart';
import 'package:rentverse_mobile/features/admin/state/moderation_notifier.dart';
import 'package:intl/intl.dart'; // Remember to add intl package to pubspec.yaml

class ModerationScreen extends ConsumerWidget {
  const ModerationScreen({super.key});

  // Initial data fetch is usually handled in the first build
  void _initializeData(WidgetRef ref, ModerationState state, ModerationNotifier notifier) {
    if (state.pendingProperties.isEmpty && !state.isLoading) {
      Future.microtask(() => notifier.fetchPendingProperties());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moderationNotifierProvider);
    final notifier = ref.read(moderationNotifierProvider.notifier);
    
    _initializeData(ref, state, notifier); // Initialize data fetch

    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Moderation'),
        actions: [
          IconButton(
            icon: state.isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.refresh),
            onPressed: state.isLoading ? null : notifier.fetchPendingProperties,
            tooltip: 'Refresh Properties',
          ),
        ],
      ),
      body: _buildBody(context, state, notifier),
    );
  }

  Widget _buildBody(BuildContext context, ModerationState state, ModerationNotifier notifier) {
    if (state.isLoading && state.pendingProperties.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(
        child: Text('Error: ${state.errorMessage}'),
      );
    }
    
    if (state.pendingProperties.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 60, color: Colors.green),
            SizedBox(height: 10),
            Text('No Pending Listings', style: TextStyle(fontSize: 18)),
            Text('The moderation queue is clear!', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    // List of pending properties
    return ListView.builder(
      itemCount: state.pendingProperties.length,
      itemBuilder: (context, index) {
        final property = state.pendingProperties[index];
        return PropertyModerationCard(property: property, notifier: notifier);
      },
    );
  }
}

class PropertyModerationCard extends StatelessWidget {
  final PropertyPending property;
  final ModerationNotifier notifier;

  const PropertyModerationCard({
    required this.property,
    required this.notifier,
    super.key,
  });

  // 🚨 THE FIX: Private instance method to access property and notifier
  void _confirmAction(BuildContext context, String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Confirmation'),
        content: Text('Are you sure you want to set the status of "${property.title}" to $action?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              notifier.updatePropertyStatus(property.id, action);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Property ${property.title} moved from moderation queue.')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: action == 'Approved' ? Colors.green : Colors.red),
            child: Text(action),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              property.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text('Landlord: ${property.landlordName}', style: const TextStyle(color: Colors.grey)),
            // Using proper formatting for currency and date
            Text('Price: ${priceFormatter.format(property.rentPrice)}/month', style: const TextStyle(fontWeight: FontWeight.w500)),
            Text('Submitted: ${DateFormat('MMM dd, yyyy HH:mm').format(property.submissionDate)}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            
            const Divider(),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Viewing Property Details is not implemented yet.')),
                    );
                  },
                  child: const Text('VIEW DETAILS'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  // 🚨 MODIFIED: Call the instance method
                  onPressed: () => _confirmAction(context, 'Rejected'),
                  style: TextButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('REJECT'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  // 🚨 MODIFIED: Call the instance method
                  onPressed: () => _confirmAction(context, 'Approved'),
                  icon: const Icon(Icons.check),
                  label: const Text('APPROVE'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
