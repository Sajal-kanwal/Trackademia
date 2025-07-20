
import 'package:flutter/material.dart' hide FilterChip;
import 'package:notesheet_tracker/widgets/common/filter_chip.dart';

class FilterChipsRow extends StatefulWidget {
  final List<Map<String, dynamic>> chips;
  final Function(String) onChipTap;

  const FilterChipsRow({super.key, required this.chips, required this.onChipTap});

  @override
  State<FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<FilterChipsRow> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.chips.length,
        itemBuilder: (context, index) {
          final chipData = widget.chips[index];
          return FilterChip(
            label: chipData['label'],
            isSelected: _selectedIndex == index,
            count: chipData['count'],
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onChipTap(chipData['label']);
            },
          );
        },
      ),
    );
  }
}
