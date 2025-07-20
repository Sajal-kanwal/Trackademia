
import 'package:flutter/material.dart';

class HistoryFiltersSection extends StatefulWidget {
  final List<String> filters;
  final String searchHint;
  final Function(String) onFilterTap;
  final Function(String) onSearchChanged;

  const HistoryFiltersSection({
    super.key,
    required this.filters,
    required this.searchHint,
    required this.onFilterTap,
    required this.onSearchChanged,
  });

  @override
  State<HistoryFiltersSection> createState() => _HistoryFiltersSectionState();
}

class _HistoryFiltersSectionState extends State<HistoryFiltersSection> {
  int _selectedFilterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: widget.searchHint,
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(),
            ),
            onChanged: widget.onSearchChanged,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.filters.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(widget.filters[index]),
                    selected: _selectedFilterIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                      widget.onFilterTap(widget.filters[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
