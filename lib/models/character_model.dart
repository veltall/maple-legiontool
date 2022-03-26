import 'package:legionprovider/models/linkskill_model.dart';
import 'package:flutter/material.dart';
import 'package:legionprovider/models/legioneffect_model.dart';

class Character extends StatelessWidget {
  final String name;
  final String? shortName;
  final int level;
  late final String _imgurl;

  late final LegionEffect legionEffect;
  late final int legionValue;
  late final LinkSkill link;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
  }) : super(key: key) {
    legionValue = calculateBonusValue();
    _imgurl = parseImgURL();
  }

  factory Character.copy(Character other) {
    return Character(
      name: other.name,
      shortName: other.shortName,
      level: other.level,
    );
  }

  factory Character.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final shortName = data['shortName'] as String?;
    final level = data['level'] as int;
    return Character(
      name: name,
      shortName: shortName,
      level: level,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      if (shortName != null) 'shortName': shortName,
      'level': level,
    };
  }

  int calculateBonusValue() {
    int value = 0;
    if (level >= 250) {
      value = legionEffect.bonusValues[4];
    } else if (level >= 200) {
      value = legionEffect.bonusValues[3];
    } else if (level >= 140) {
      value = legionEffect.bonusValues[2];
    } else if (level >= 100) {
      value = legionEffect.bonusValues[1];
    } else if (level >= 60) {
      value = legionEffect.bonusValues[0];
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
    final String cardTitle = (shortName != null) ? shortName.toString() : name;
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
                        cardTitle,
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
                    legionEffect.bonusStat +
                        " +" +
                        legionValue.toString() +
                        legionEffect.bonusUnit,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 8.0),
                      Text("Bonus: " + legionEffect.bonusValues.toString()),
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
                    image: AssetImage(_imgurl),
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
    return LinkSkill();
  }
}
