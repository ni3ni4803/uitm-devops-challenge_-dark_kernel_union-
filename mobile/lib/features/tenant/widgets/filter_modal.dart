import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rentverse_mobile/features/tenant/state/filter_notifier.dart';

class FilterModal extends ConsumerStatefulWidget {
  const FilterModal({super.key});

  @override
  ConsumerState<FilterModal> createState() => _FilterModalState();
}

class _FilterModalState extends ConsumerState<FilterModal> {
  late RangeValues _currentRangeValues;
  // NEW: Local state for property type
  late String _selectedType;

  static const double _minLimit = 0.0;
  static const double _maxLimit = 10000.0;
  
  // List of property types (you can move this to a constant file later)
  final List<String> _propertyTypes = ['All', 'Apartment', 'House', 'Villa', 'Studio'];

  @override
  void initState() {
    super.initState();
    final currentFilter = ref.read(filterNotifierProvider);
    _currentRangeValues = RangeValues(
      currentFilter.minRent,
      currentFilter.maxRent,
    );
    // Initialize local type from current filter state
    _selectedType = currentFilter.propertyType;
  }

  String _formatRent(double value) {
    if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
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
          const Text(
            'Filter Listings',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),

          // --- Price Range Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Monthly Rent Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(
                '${_formatRent(_currentRangeValues.start)} - ${_formatRent(_currentRangeValues.end)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
              ),
            ],
          ),
          RangeSlider(
            values: _currentRangeValues,
            min: _minLimit,
            max: _maxLimit,
            divisions: 100,
            onChanged: (values) => setState(() => _currentRangeValues = values),
          ),

          const SizedBox(height: 20),

          // --- Property Type Section (NEW) ---
          const Text('Property Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            children: _propertyTypes.map((type) {
              final isSelected = _selectedType == type;
              return ChoiceChip(
                label: Text(type),
                selected: isSelected,
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                checkmarkColor: Theme.of(context).primaryColor,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedType = type);
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 30),

          // --- Action Buttons ---
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  ref.read(filterNotifierProvider.notifier).resetFilters();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                  onPressed: () {
                    // Update both price and type in the global state
                    final notifier = ref.read(filterNotifierProvider.notifier);
                    notifier.updatePriceRange(
                      min: _currentRangeValues.start,
                      max: _currentRangeValues.end,
                    );
                    notifier.updatePropertyType(_selectedType); 
                    
                    Navigator.of(context).pop();
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