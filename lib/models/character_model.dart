import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:legionprovider/models/linkskill_model.dart';
import 'package:flutter/material.dart';
import 'package:legionprovider/models/legioneffect_model.dart';

class Character extends StatefulWidget {
  final String name;
  final String? shortName;
  final int level;
  late final String _imgurl;

  late final Map<String, dynamic> linkMap;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
  }) : super(key: key) {
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

  // int calculateBonusValue() {
  //   return legionEffect.calculateBonusValue(level);
  // }

  String parseImgURL() {
    String url = "./img/" + name.replaceAll(' ', '') + ".webp";
    return url;
  }

  @override
  State<Character> createState() => _CharacterState();
}

class _CharacterState extends State<Character> {
  Map<String, dynamic> legionMap = {};

  Map<String, dynamic> toMap() {
    return {
      'name': widget.name,
      if (widget.shortName != null) 'shortName': widget.shortName,
      'level': widget.level,
    };
  }

  Future<void> readLegionJson() async {
    final String response = await rootBundle.loadString('character.json');
    final data = await json.decode(response);
    setState(() {
      legionMap = data.firstWhere((char) {
        return char["name"] == widget.name;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readLegionJson();
  }

  @override
  Widget build(BuildContext context) {
    return _buildFront(context);
  }

  Widget _buildFront(BuildContext context) {
    final String cardTitle =
        (widget.shortName != null) ? widget.shortName.toString() : widget.name;
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
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Level " + widget.level.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey.shade300,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              (legionMap["name"] != null)
                  ? LegionEffect.fromMap(legionMap)
                  : const RefreshProgressIndicator(
                      value: null,
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
                    image: AssetImage(widget._imgurl),
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
