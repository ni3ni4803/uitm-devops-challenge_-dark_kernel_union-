import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart';

// Use ConsumerStatefulWidget because we need local state for the slider
class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  // Use a local variable to hold the slider value until the user hits "Apply"
  late RangeValues _currentRangeValues;

  // Define the absolute range limits based on the PropertyFilter defaults
  static const double _minLimit = 0.0;
  static const double _maxLimit = 10000.0;

  @override
  void initState() {
    super.initState();
    // Initialize the local state with the global filter state
    final currentFilter = ref.read(filterNotifierProvider);
    _currentRangeValues = RangeValues(
      currentFilter.minRent,
      currentFilter.maxRent,
    );
  }

  // Format the rent value for display
  String _formatRent(double value) {
    if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(1)}K';
    }
    return '\$${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Filter Listings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),

          // Price Range Title and Values
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monthly Rent Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(
                '${_formatRent(_currentRangeValues.start)} - ${_formatRent(_currentRangeValues.end)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Range Slider
          RangeSlider(
            values: _currentRangeValues,
            min: _minLimit,
            max: _maxLimit,
            divisions: 100, // Provides fine-grained control
            labels: RangeLabels(
              _formatRent(_currentRangeValues.start),
              _formatRent(_currentRangeValues.end),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentRangeValues = values;
              });
            },
          ),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              // Reset Button
              OutlinedButton(
                onPressed: () {
                  ref.read(filterNotifierProvider.notifier).resetFilters();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 10),

              // Apply Button
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () {
                    // Commit the local slider state to the global Riverpod state
                    ref.read(filterNotifierProvider.notifier).updatePriceRange(
                      min: _currentRangeValues.start,
                      max: _currentRangeValues.end,
                    );
                    Navigator.of(context).pop(); // Close the modal
                  },
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}