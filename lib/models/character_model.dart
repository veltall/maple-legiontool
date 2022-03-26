import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Character extends StatelessWidget {
  final String name;
  final String? shortName;
  final int level;
  final String bonusStat;
  final List<int> bonusValues;
  final String bonusUnit;
  late final String imgurl;
  late final int bonusValue;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
    required this.bonusStat,
    required this.bonusValues,
    required this.bonusUnit,
  }) : super(key: key) {
    bonusValue = calculateBonusValue();
    imgurl = parseImgURL();
  }

  factory Character.copy(Character other) {
    return Character(
      name: other.name,
      shortName: other.shortName,
      level: other.level,
      bonusStat: other.bonusStat,
      bonusValues: other.bonusValues,
      bonusUnit: other.bonusUnit,
    );
  }

  factory Character.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final shortName = data['shortName'] as String?;
    final level = data['level'] as int;
    final bonusStat = data['bonusStat'] as String;
    final bonus = data['bonusValues'] as List<dynamic>;
    final bonusValues = bonus.map((n) => n as int).toList();
    final bonusUnit = data['unit'] as String;
    return Character(
      name: name,
      shortName: shortName,
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
      'level': level,
      'bonusStat': bonusStat,
      'bonusValues': bonusValues,
      'unit': bonusUnit,
    };
  }

  int calculateBonusValue() {
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

  String parseImgURL() {
    String url = "./img/" + name.replaceAll(' ', '') + ".webp";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return _buildFront(context);
  }

  Widget _buildFront(BuildContext context) {
    return Container(
      key: const ValueKey(true),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red,
            Colors.blue,
          ],
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 180),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 20,
                    right: 8,
                    bottom: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "Level " + level.toString(),
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.grey.shade300,
                              decoration: TextDecoration.underline,
                            ),
                      ),
                    ],
                  )),
              const Spacer(),
              Card(
                child: ListTile(
                  title: Text(
                    bonusStat + " +" + bonusValue.toString() + bonusUnit,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      Text("Bonus: " + bonusValues.toString()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.topRight,
                  heightFactor: 0.75,
                  child: Image(
                    image: AssetImage(imgurl),
                    height: 210,
                    opacity: const AlwaysStoppedAnimation<double>(0.75),
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRear(BuildContext context) {
    return Container();
  }
}
