import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/data/models/user.dart'; 
import 'package:rentverse_mobile/features/auth/state/auth_notifier.dart';
import 'package:go_router/go_router.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers initialized with current user data
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  
  late final User? currentUser; 

  @override
  void initState() {
    super.initState();
    
    currentUser = ref.read(authNotifierProvider);
    
    // Use an assertion to ensure the user is logged in before accessing data
    assert(currentUser != null, 'User must be logged in to edit profile.');
    
    _fullNameController = TextEditingController(text: currentUser!.fullName);
    _emailController = TextEditingController(text: currentUser!.email);
  }

  Future<void> _handleSave() async {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would involve calling a service to update the user profile
      // For this mock implementation, we just show a success message.
      
      final newFullName = _fullNameController.text.trim();
      
      // 2. Simulate update success
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Note: If you want to see the name update on the screen, 
      // you would need to implement an updateUser method in AuthNotifier
      // and call ref.read(authNotifierProvider.notifier).updateUser(updatedUser); 
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully! Name: $newFullName'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'), // Pop returns to the previous screen
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Full name is required' : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address (Read-only)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                readOnly: true, // Email is typically not editable
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save Changes', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              
              // Placeholder for Password Change button (next step)
              TextButton(
            onPressed: () {
              // Navigate to the new Password Change Screen
              context.go('/change-password'); 
            },
            child: const Text('Change Password'),
          ),
            ],
          ),
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}