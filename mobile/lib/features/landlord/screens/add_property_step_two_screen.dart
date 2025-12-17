import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_notifier.dart';


// Mock list of common amenities
const List<String> _mockAmenities = [
  'In-Unit Laundry',
  'Central AC',
  'Dishwasher',
  'Garage Parking',
  'Pet Friendly',
  'Gym/Fitness Center',
  'Pool',
  'Balcony/Patio',
];

class AddPropertyStepTwoScreen extends ConsumerStatefulWidget {
  const AddPropertyStepTwoScreen({super.key});

  @override
  ConsumerState<AddPropertyStepTwoScreen> createState() =>
      _AddPropertyStepTwoScreenState();
}

class _AddPropertyStepTwoScreenState extends ConsumerState<AddPropertyStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // State variables to hold selections
  late int _selectedBedrooms;
  // Must be double to match the Notifier
  late double _selectedBathrooms; 
  late List<String> _selectedAmenities;

  @override
  void initState() {
    super.initState();
    // Initialize state with current data from the notifier
    final state = ref.read(propertyCreationNotifierProvider);
    
    // Use the value from state, defaulting to 1
    _selectedBedrooms = state.bedrooms;
    
    // Initialize bathrooms as double
    _selectedBathrooms = state.bathrooms;
    _selectedAmenities = List.from(state.amenities); // Use a copy
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      // 1. Update the Riverpod state with current values
      // 🚨 FIX: Using the CORRECT method name: updateDetailsAndLocation
      ref.read(propertyCreationNotifierProvider.notifier).updateDetailsAndLocation( 
            bedrooms: _selectedBedrooms,
            bathrooms: _selectedBathrooms, 
            amenities: _selectedAmenities,
            // Latitude/Longitude default values are handled by the notifier/model
          );

      // 2. Navigate to the next step (Step 3: Description & Media)
      context.go('/landlord/add-property/description');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Property (2/3)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigate back to Step 1 without resetting the form
          onPressed: () => context.go('/landlord/add-property'),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Property Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // --- Bedrooms Dropdown (Int) ---
              DropdownButtonFormField<int>(
                initialValue: _selectedBedrooms, 
                decoration: const InputDecoration(
                  labelText: 'Bedrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed),
                ),
                items: List.generate(6, (i) => i + 1) // 1 to 6
                    .map((int value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value Bedroom${value > 1 ? 's' : ''}'),
                        ))
                    .toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedBedrooms = newValue ?? 1;
                  });
                },
                validator: (value) => value == null ? 'Please select a value' : null,
              ),
              const SizedBox(height: 20),

              // --- Bathrooms Dropdown (Double) ---
              DropdownButtonFormField<double>(
                initialValue: _selectedBathrooms, 
                decoration: const InputDecoration(
                  labelText: 'Bathrooms',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bathtub),
                ),
                // Generate list of doubles (1.0, 1.5, 2.0, etc.)
                items: [1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0]
                    .map((double value) => DropdownMenuItem<double>(
                          value: value,
                          child: Text(value.toString()),
                        ))
                    .toList(),
                onChanged: (double? newValue) {
                  setState(() {
                    _selectedBathrooms = newValue ?? 1.0;
                  });
                },
                validator: (value) => value == null ? 'Please select a value' : null,
              ),
              const SizedBox(height: 40),

              // --- Amenities Section ---
              Text(
                'Amenities',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 8.0,
                children: _mockAmenities.map((amenity) {
                  return FilterChip(
                    label: Text(amenity),
                    selected: _selectedAmenities.contains(amenity),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedAmenities.add(amenity);
                        } else {
                          _selectedAmenities.remove(amenity);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Next: Description & Media', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
