import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:football/core/api/dio_consumer.dart';
import 'package:football/core/screens/exercieses_list.dart';
import 'package:football/core/utils/empty_state.dart';
import 'package:football/core/utils/loading_grid.dart';
import 'package:football/core/widgets/category_card.dart';
import 'package:football/core/widgets/custom_appbar.dart';

class ExerciesesCategoriesListScreen extends StatefulWidget {
  final String title;
  final String listEndpoint;
  final String Function(String item) getNextEndpoint;

  const ExerciesesCategoriesListScreen({
    super.key,
    required this.title,
    required this.listEndpoint,
    required this.getNextEndpoint,
  });

  @override
  State<ExerciesesCategoriesListScreen> createState() =>
      _StringListScreenState();
}

class _StringListScreenState extends State<ExerciesesCategoriesListScreen> {
  List<String> _allItems = [];
  List<String> _filteredItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    try {
      final consumer = DioConsumer(dio: Dio());
      final data = await consumer.get(widget.listEndpoint);

      if (!mounted) return;

      setState(() {
        _allItems = List<String>.from(data);
        _filteredItems = _allItems;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearch(String value) {
    setState(() {
      _filteredItems =
          _allItems
              .where((e) => e.toLowerCase().contains(value.toLowerCase()))
              .toList();
    });
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: CustomAppBar(title: widget.title),
      body: Column(
        children: [
          SearchBarContainer(onChanged: _onSearch),
          Expanded(
            child:
                _isLoading
                    ? const LoadingGrid()
                    : _filteredItems.isEmpty
                    ? const EmptyState()
                    : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 1.15,
                          ),
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return CategoryCard(
                          title: _capitalize(item),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => ExerciseListScreen(
                                      title: _capitalize(item),
                                      apiPath: widget.getNextEndpoint(item),
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

class SearchBarContainer extends StatelessWidget {
  final ValueChanged<String> onChanged;

  const SearchBarContainer({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
