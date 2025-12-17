import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart'; // 🚨 IMPORT ADDED
import 'package:rentverse_mobile/features/landlord/state/landlord_applications_notifier.dart';

class LandlordApplicationsScreen extends ConsumerWidget {
  const LandlordApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationsAsync = ref.watch(landlordApplicationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Received Applications'),
      ),
      body: applicationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading applications: $err')),
        data: (apps) {
          if (apps.isEmpty) {
            return const Center(child: Text('No applications received yet.'));
          }
          return ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              final app = apps[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(app.fullName),
                  subtitle: Text(
                      'Property ID: ${app.propertyId} • Income: \$${app.currentMonthlyIncome}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // 🚨 FIX: Navigate to detail review screen passing the app object
                    context.push('/landlord/application-detail', extra: app);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}