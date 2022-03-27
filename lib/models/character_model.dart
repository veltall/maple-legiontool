import 'dart:convert';
import 'dart:ui';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/services.dart';
import 'package:legionprovider/models/linkskill_model.dart';
import 'package:flutter/material.dart';
import 'package:legionprovider/models/legioneffect_model.dart';
import 'package:simple_shadow/simple_shadow.dart';

class Character extends StatefulWidget {
  final String name;
  final String? shortName;
  final int level;
  late final String _imgurl;
  final String pcolor;
  final String scolor;
  final bool isTera;
  final bool isMega;

  late final Map<String, dynamic> linkMap;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
    this.pcolor = "#ffffff",
    this.scolor = "#000000",
    this.isMega = false,
    this.isTera = false,
  }) : super(key: key) {
    _imgurl = parseImgURL();
  }

  factory Character.copy(Character other) {
    return Character(
      name: other.name,
      shortName: other.shortName,
      level: other.level,
      pcolor: other.pcolor,
      scolor: other.scolor,
      isMega: other.isMega,
      isTera: other.isTera,
    );
  }

  factory Character.fromMap(Map<String, dynamic> data) {
    final name = data['name'] as String;
    final shortName = data['shortName'] as String?;
    final level = data['level'] as int;
    final _pcolor = data['color'] as String;
    final _scolor = data['secondaryColor'] as String;
    final _tera = data['tera'] as bool;
    final _mega = data['mega'] as bool;
    return Character(
      name: name,
      shortName: shortName,
      level: level,
      pcolor: _pcolor,
      scolor: _scolor,
      isMega: _mega,
      isTera: _tera,
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
    return FlipCard(
      flipOnTouch: true,
      direction: FlipDirection.VERTICAL,
      front: _buildFront(context),
      back: _buildRear(context),
    );
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget _buildFront(BuildContext context) {
    final String cardTitle =
        (widget.shortName != null) ? widget.shortName.toString() : widget.name;
    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            hexToColor(widget.pcolor),
            hexToColor(widget.scolor),
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
                  top: 8,
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
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Level " + widget.level.toString(),
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.grey.shade200,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    Row(
                      children: [
                        widget.isTera
                            ? const BurningIcon(burningType: 'tera')
                            : Container(),
                        widget.isMega
                            ? const BurningIcon(burningType: 'mega')
                            : Container(),
                      ],
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
                  child: SimpleShadow(
                    opacity: 0.55,
                    offset: const Offset(-7, 5),
                    sigma: 7,
                    child: Image(
                      image: AssetImage(widget._imgurl),
                      height: 210,
                      opacity: const AlwaysStoppedAnimation<double>(0.75),
                    ),
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

class BurningIcon extends StatelessWidget {
  final String burningType;
  const BurningIcon({Key? key, required this.burningType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Colors.grey.shade200,
          fontSize: 10,
        );
    bool isTera = (burningType == "tera");
    Widget burnText = isTera
        ? Text(
            "200",
            style: style,
          )
        : Text(
            "150",
            style: style,
          );
    Color teraColor = Colors.red.shade900;
    Color megaColor = const Color.fromARGB(255, 149, 125, 0);
    return BackdropFilter(
      filter: ImageFilter.blur(
          // sigmaX: 2,
          // sigmaY: 2,
          ),
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(top: 4, right: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black,
        ),
        child: Stack(
          children: [
            Center(
              child: Icon(
                Icons.local_fire_department_sharp,
                color: isTera ? teraColor : megaColor,
              ),
            ),
            Align(
              alignment: const Alignment(0.9, 0.9),
              child: burnText,
            ),
          ],
        ),
      ),
    );
  }
}
