import 'package:flutter/material.dart';

class LinkSkill extends StatelessWidget {
  final String name;
  final String job;
  final String desc;
  final List<LinkBonus> bonuses;
  late final String imgurl;

  LinkSkill({
    Key? key,
    required this.name,
    required this.job,
    required this.desc,
    required this.bonuses,
  }) : super(key: key) {
    imgurl = parseImageURL();
  }

  factory LinkSkill.fromMap(Map<String, dynamic> linkMap) {
    final name = linkMap['name'] as String;
    final job = linkMap['job'] as String;
    final desc = linkMap['desc'] as String;
    final bonuses = linkMap['bonuses'] as List<dynamic>;
    final linkBonuses = bonuses.map((listItem) {
      return listItem as Map<String, dynamic>;
    });
    final linkList = linkBonuses.map((m) {
      return LinkBonus.fromMap(m);
    }).toList();
    return LinkSkill(
      name: name,
      job: job,
      desc: desc,
      bonuses: linkList,
    );
  }

  String parseImageURL() {
    String url = "./img/" + name.replaceAll(' ', '') + ".webp";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      color: Theme.of(context).primaryColorLight,
    );
  }
}

class LinkBonus {
  final String stat;
  final String desc;
  final List<int> values;
  final String unit;

  LinkBonus({
    required this.stat,
    required this.desc,
    required this.values,
    required this.unit,
  });

  factory LinkBonus.fromMap(Map bonusMap) {
    final stat = bonusMap['stat'] as String;
    final desc = bonusMap['desc'] as String;
    final val = bonusMap['values'] as List<dynamic>;
    final values = val.map((v) => v as int).toList();
    final unit = bonusMap['unit'] as String;
    return LinkBonus(
      stat: stat,
      desc: desc,
      values: values,
      unit: unit,
    );
  }

  int getBonusValue(int level) {
    int value = 0;
    int len = values.length;
    if (level >= 210 && len == 3) {
      value = values[len - 1];
    } else if (level >= 120) {
      value = values[1];
    } else if (level >= 70) {
      value = values[0];
    }
    return value;
  }
}
