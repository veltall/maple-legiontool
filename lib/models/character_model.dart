import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  final String name;
  final String? shortName;
  final String imgurl;
  final int level;
  final String bonusStat;
  final List<int> bonusValues;
  final String bonusUnit;
  late final int bonusValue;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.imgurl,
    required this.level,
    required this.bonusStat,
    required this.bonusValues,
    required this.bonusUnit,
  }) : super(key: key) {
    bonusValue = calculateBonusValue();
  }

  factory Character.copy(Character other) {
    return Character(
      name: other.name,
      shortName: other.shortName,
      imgurl: other.imgurl,
      level: other.level,
      bonusStat: other.bonusStat,
      bonusValues: other.bonusValues,
      bonusUnit: other.bonusUnit,
    );
  }

  factory Character.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final shortName = data['shortName'] as String?;
    final imgurl = data['imgsrc'] as String?;
    final level = data['level'] as int;
    final bonusStat = data['bonusStat'] as String;
    final bonus = data['bonusValues'] as List<dynamic>;
    final bonusValues = bonus.map((n) => n as int).toList();
    final bonusUnit = data['unit'] as String;
    return Character(
      name: name,
      shortName: shortName,
      imgurl: imgurl ?? "./img/mushroom.png",
      level: level,
      bonusStat: bonusStat,
      bonusValues: bonusValues,
      bonusUnit: bonusUnit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (shortName != null) 'shortName': shortName,
      'imgsrc': imgurl,
      'level': level,
      'bonusStat': bonusStat,
      'bonusValues': bonusValues,
      'unit': bonusUnit,
    };
  }

  int calculateBonusValue() {
    return bonusValues[2];
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = Colors.grey.shade200;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: cardColor,
        child: Stack(
          children: [
            ClipRect(
              child: Align(
                alignment: Alignment.centerRight,
                heightFactor: 0.65,
                child: Image(
                  image: AssetImage(imgurl),
                  height: 220,
                  opacity: const AlwaysStoppedAnimation<double>(0.75),
                  // colorBlendMode: BlendMode.darken,
                  // color: Colors.white,
                ),
              ),
            ),
            ListTile(
              title: Align(
                alignment: Alignment.centerLeft,
                child: BorderedText(
                  strokeColor: Colors.black,
                  strokeJoin: StrokeJoin.bevel,
                  strokeWidth: 4.0,
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          letterSpacing: 2.5,
                        ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Text("Level " + level.toString()),
                  Text("Bonus: " + bonusValues.toString()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
