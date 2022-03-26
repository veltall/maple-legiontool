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
    final bonusValues = data['bonusValues'] as List;
    return Character(
      name: name,
      shortName: shortName,
      level: level,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
