import 'package:flutter/material.dart';

class LegionEffect extends StatelessWidget {
  final String job;
  final String bonusStat;
  final List<int> bonusValues;
  final String bonusUnit;

  const LegionEffect({
    Key? key,
    required this.job,
    required this.bonusStat,
    required this.bonusValues,
    required this.bonusUnit,
  }) : super(key: key);

  factory LegionEffect.fromMap(Map<String, dynamic> data) {
    final job = data['name'] as String;
    final bonusStat = data['bonusStat'] as String;
    final bonusUnit = data['unit'] as String;
    final bonus = data['bonusValues'] as List<dynamic>;
    final bonusValues = bonus.map((b) => b as int).toList();
    return LegionEffect(
      job: job,
      bonusStat: bonusStat,
      bonusUnit: bonusUnit,
      bonusValues: bonusValues,
    );
  }

  int calculateBonusValue(int level) {
    int value = 0;
    if (level >= 250) {
      value = bonusValues[4];
    } else if (level >= 200) {
      value = bonusValues[3];
    } else if (level >= 140) {
      value = bonusValues[2];
    } else if (level >= 100) {
      value = bonusValues[1];
    } else if (level >= 60) {
      value = bonusValues[0];
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.indigo,
    );
  }
}
