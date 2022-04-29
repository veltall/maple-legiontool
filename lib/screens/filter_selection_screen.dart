// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:legionprovider/models/character_model.dart';
import 'package:legionprovider/providers/legion_provider.dart';

class FilterSelectionPage extends ConsumerWidget {
  static const List<String> availableFilters = [
    'STR',
    'DEX',
    'INT',
    'LUK',
    'Critical Hit Rate',
    'Critical Damage',
    'Boss Damage',
    'IED',
  ];
  const FilterSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = FilterSelectionPage.availableFilters.length;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Character Filter"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(filterValuesProvider.state).state =
                  List.generate(itemCount, (index) => false);
            },
            icon: const Icon(Icons.clear_all),
          ),
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: FilterSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (context, index) {
            final filter = FilterSelectionPage.availableFilters[index];
            List<bool> checkboxes = ref.watch(filterValuesProvider);
            return Card(
              color: (checkboxes[index] == true)
                  ? Theme.of(context).colorScheme.background
                  : null,
              child: CheckboxListTile(
                title: Text(
                  filter,
                  style: TextStyle(
                    color: (checkboxes[index] == true) ? Colors.white : null,
                  ),
                ),
                onChanged: (value) {
                  final front = checkboxes.sublist(0, index);
                  final rear = checkboxes.sublist(index + 1, itemCount);
                  ref.read(filterValuesProvider.state).state = [
                    ...front,
                    value!,
                    ...rear
                  ];
                },
                value: checkboxes[index],
              ),
            );
          },
          itemCount: itemCount,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}

class FilterSearchDelegate extends SearchDelegate {
  List<String> searchResults = FilterSelectionPage.availableFilters;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(
        query,
        style: const TextStyle(
          fontSize: 64,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((result) {
      final searchResult = result.toLowerCase();
      final input = query.toLowerCase();
      return searchResult.contains(input);
    }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      },
    );
  }
}
