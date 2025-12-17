import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rentverse_mobile/features/tenant/state/application_notifier.dart';

class ApplicationStepTwoScreen extends ConsumerStatefulWidget {
  final String propertyId;
  const ApplicationStepTwoScreen({super.key, required this.propertyId});

  @override
  ConsumerState<ApplicationStepTwoScreen> createState() =>
      _ApplicationStepTwoScreenState();
}

class _ApplicationStepTwoScreenState
    extends ConsumerState<ApplicationStepTwoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _incomeController;
  late final TextEditingController _employerNameController;
  late final TextEditingController _employerPhoneController;
  late final TextEditingController _employmentDurationController; // 🚨 NEW

  @override
  void initState() {
    super.initState();

    final state = ref.read(applicationNotifierProvider(widget.propertyId));

    _incomeController = TextEditingController(
      text: state.currentMonthlyIncome > 0
          ? state.currentMonthlyIncome.toString()
          : '',
    );
    _employerNameController =
        TextEditingController(text: state.employerName);
    _employerPhoneController =
        TextEditingController(text: state.employerPhone);
    _employmentDurationController = 
        TextEditingController(text: state.employmentDuration); // 🚨 NEW
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _employerNameController.dispose();
    _employerPhoneController.dispose();
    _employmentDurationController.dispose(); // 🚨 NEW
    super.dispose();
  }

  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      ref
          .read(applicationNotifierProvider(widget.propertyId).notifier)
          .updateFinancialInfo(
            currentMonthlyIncome:
                double.parse(_incomeController.text.trim()),
            employerName: _employerNameController.text.trim(),
            employerPhone: _employerPhoneController.text.trim(),
            employmentDuration: _employmentDurationController.text.trim(), // 🚨 NEW
          );

      if (!mounted) return;
      context.go('/apply/residence/${widget.propertyId}');
    }
  }

  void _handleBack() {
    context.go('/apply/${widget.propertyId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Application (2/4): Financial Info'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Financial & Employment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // --- Monthly Income ---
              TextFormField(
                controller: _incomeController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Current Monthly Income (Gross)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (value) {
                  final income = double.tryParse(value ?? '');
                  if (income == null || income <= 0) {
                    return 'Must enter a positive monthly income';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // --- Employer Name ---
              TextFormField(
                controller: _employerNameController,
                decoration: const InputDecoration(
                  labelText: 'Employer Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // --- Employer Phone ---
              TextFormField(
                controller: _employerPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Employer Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                validator: (value) =>
                    value == null || value.length < 8
                        ? 'Valid phone required'
                        : null,
              ),
              const SizedBox(height: 20),

              // --- Employment Duration ---
              TextFormField(
                controller: _employmentDurationController,
                decoration: const InputDecoration(
                  labelText: 'How long have you been employed here?',
                  hintText: 'e.g. 2 years, 6 months',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.timer),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _handleBack,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _handleNext,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Next: Residence',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}