import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/landlord/state/property_creation_notifier.dart';

class AddPropertyStepThreeScreen extends ConsumerStatefulWidget {
  const AddPropertyStepThreeScreen({super.key});

  @override
  ConsumerState<AddPropertyStepThreeScreen> createState() =>
      _AddPropertyStepThreeScreenState();
}

class _AddPropertyStepThreeScreenState extends ConsumerState<AddPropertyStepThreeScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize controller with current state data
    final state = ref.read(propertyCreationNotifierProvider);
    _descriptionController = TextEditingController(text: state.description);
  }
  
  // 🚨 NEW: Use watch for dynamic title (like steps 1 and 2)
  String get _titleText {
    final creationState = ref.read(propertyCreationNotifierProvider);
    return creationState.id != null ? 'Edit Listing (3/3)' : 'Add New Property (3/3)';
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get the current state model to check if we are editing
      final creationState = ref.read(propertyCreationNotifierProvider);

      // 1. Update the final pieces of Riverpod state
      // 🚨 FIX: Method name changed to updateDescriptionAndMedia
      ref.read(propertyCreationNotifierProvider.notifier).updateDescriptionAndMedia( 
        description: _descriptionController.text.trim(),
        imageUrls: [
          // Ensure a unique placeholder based on the property ID or Title
          'https://via.placeholder.com/600x400?text=${creationState.id ?? creationState.title.replaceAll(' ', '+')}',
        ],
      );

      // 2. Determine whether to ADD or UPDATE
      final bool success;
      final String actionVerb;

      if (creationState.id != null) {
        // We are EDITING
        success = await ref.read(propertyCreationNotifierProvider.notifier).updateProperty(); 
        actionVerb = 'updated';
      } else {
        // We are ADDING
        success = await ref.read(propertyCreationNotifierProvider.notifier).submitProperty();
        actionVerb = 'added';
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Property $actionVerb successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          // 3. Navigate back to the Landlord Dashboard
          context.go('/landlord');
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titleText), // 🚨 FIX: Use the dynamic title getter
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          // Navigate back to Step 2 without resetting the form
          onPressed: () => context.go('/landlord/add-property/details'),
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
                'Description and Media',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  labelText: 'Property Description',
                  hintText: 'Describe the unique features and neighborhood.',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty || value.length < 50
                    ? 'Description must be at least 50 characters long.'
                    : null,
              ),
              const SizedBox(height: 40),

              // Placeholder for Image Upload
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Property Photos (Mock)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : () {
                      // Mock implementation: Simulate image selection
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image selection mocked. Mock URL will be used.')),
                      );
                    },
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Select Cover Photo'),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Submit Property Listing', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
