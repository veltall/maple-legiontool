import 'package:flutter_riverpod/flutter_riverpod.dart';

final characterListProvider = StateProvider((ref) {
  return [];
});

final characterFilterProvider = StateProvider((ref) {
  return 'str';
});

final filteredCharacterListProvider = StateProvider((ref) {
  // possible values: none, str, dex, int, luk, critrate, critdamage, boss, ied
  final filter = ref.watch(characterFilterProvider);
  final list = ref.watch(characterListProvider);
  var filteredList = [];
  if (filter != 'none') {
    for (var c in list) {
      var stat = (c['bonusStat'] as String).toLowerCase().replaceAll(' ', '');
      if (stat == filter) {
        filteredList.add(c);
      }
    }
    return filteredList;
  }
  return list;
});

final legionLevelProvider = StateProvider((ref) {
  final list = ref.watch(filteredCharacterListProvider);
  var levels = 0;
  for (var item in list) {
    levels += item["level"] as int;
  }
  return levels;
});
