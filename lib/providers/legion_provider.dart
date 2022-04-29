import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/filter_selection_screen.dart';

final characterListProvider = StateProvider((ref) {
  return [];
});

final filteredCharacterListProvider = StateProvider((ref) {
  // possible values: none, str, dex, int, luk, critrate, critdamage, boss, ied
  const availFilters = FilterSelectionPage.availableFilters;
  final filterBooleans = ref.watch(filterValuesProvider);
  var filterList = [];
  for (var i = 0; i < availFilters.length; i++) {
    if (filterBooleans[i] == true) {
      filterList.add(availFilters[i]);
    }
  }
  // have the list of filter texts in `filteredList`
  final charList = ref.watch(characterListProvider);
  final filteredCharList = [];

  for (Map charMap in charList) {
    final stat =
        (charMap['bonusStat'] as String).toLowerCase().replaceAll(' ', '');
    for (String f in filterList) {
      final filterText = f.toLowerCase().replaceAll(' ', '');
      if (stat == filterText) {
        filteredCharList.add(charMap);
      }
    }
  }
  if (filteredCharList.isEmpty) {
    return charList;
  } else {
    return filteredCharList;
  }
});

final legionLevelProvider = StateProvider((ref) {
  final list = ref.watch(filteredCharacterListProvider);
  var levels = 0;
  for (var item in list) {
    levels += item["level"] as int;
  }
  return levels;
});

final filterValuesProvider = StateProvider((ref) {
  final length = FilterSelectionPage.availableFilters.length;
  return List.generate(length, (index) => false);
});
