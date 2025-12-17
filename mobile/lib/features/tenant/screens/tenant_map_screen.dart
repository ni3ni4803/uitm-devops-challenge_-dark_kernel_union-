import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rentverse_mobile/features/tenant/state/property_list_notifier.dart';
import 'package:go_router/go_router.dart'; 


class TenantMapScreen extends ConsumerWidget {
  const TenantMapScreen({super.key});

  // Default camera position focused on the general area of our mock data (Los Angeles)
  static const CameraPosition _kInitialPosition = CameraPosition(
    target: LatLng(34.0522, -118.2437), 
    zoom: 12,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final propertyListAsyncValue = ref.watch(propertyListNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Map View'),
      ),
      body: propertyListAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Map Error: $err')),
        data: (properties) {
          final markers = <Marker>{};

          for (final property in properties) {
            markers.add(
              Marker(
                markerId: MarkerId(property.id),
                position: LatLng(property.latitude, property.longitude),
                infoWindow: InfoWindow(
                  title: property.title,
                  snippet: '\$${property.monthlyRent.toStringAsFixed(0)}/mo',
                  // 2. FIX APPLIED HERE: Implement onTap to navigate to detail screen
                  onTap: () {
                    // Use GoRouter to navigate, passing the property ID in the path
                    context.go('/property/${property.id}');
                  },
                ),
              ),
            );
          }

          return GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kInitialPosition,
            markers: markers,
            // TODO: Add onMapCreated logic later if needed
          );
        },
      ),
    );
  }
}