import 'dart:convert';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:legionprovider/models/legioneffect_model.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:legionprovider/models/linkskill_model.dart';

class Character extends StatefulWidget {
  final String name;
  final String? shortName;
  final int level;
  late final String _imgurl;
  final String pcolor;
  final String scolor;
  final bool isTera;
  final bool isMega;
  final LinkSkill linkSkill;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
    required this.linkSkill,
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
      linkSkill: other.linkSkill,
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
    final linkMap = data['linkSkill'] as Map<String, dynamic>;
    // final Map<String, dynamic> linkMap = {};
    final linkSkill = LinkSkill.fromMap(linkMap);
    return Character(
      name: name,
      shortName: shortName,
      level: level,
      linkSkill: linkSkill,
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
  Map<String, dynamic> characterMap = {};
  late FlipCardController _controller;

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
      characterMap = data.firstWhere((char) {
        return char["name"] == widget.name;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readLegionJson();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: _controller,
      flipOnTouch: false,
      direction: FlipDirection.VERTICAL,
      front: _buildFront(context),
      back: _buildRear(context),
    );
  }

  Widget _buildFront(BuildContext context) {
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
          transform: const GradientRotation(135 * pi / 180),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Stack(
        children: [
          buildCharacterInfo(),
          buildHeroImage(),
        ],
      ),
    );
  }

  Widget _buildRear(BuildContext context) {
    // return LinkSkill();
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
          transform: const GradientRotation(135 * pi / 180),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 200),
      child: Stack(
        children: [
          buildTitleBar(title: "Elementalism"),
          buildHeroImage(),
        ],
      ),
    );
  }

  /// Construct a color from a hex code string, of the format #RRGGBB.
  Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget buildCharacterInfo() {
    final String cardTitle =
        (widget.shortName != null) ? widget.shortName.toString() : widget.name;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTitleBar(title: cardTitle),
              buildStatusBar(),
            ],
          ),
        ),
        // const Spacer(),
        buildCTAButton(),
        (characterMap["name"] != null)
            ? LegionEffect.fromMap(characterMap)
            : const RefreshProgressIndicator(
                value: null,
              ),
      ],
    );
  }

  Widget buildTitleBar({required String title}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SimpleShadow(
          offset: const Offset(-3, 2),
          opacity: 0.5,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        buildCardFlipIconButton(),
      ],
    );
  }

  Widget buildStatusBar() {
    return Row(
      children: [
        widget.isTera
            ? const BurningIcon(burningType: 'tera')
            : const SizedBox(height: 30),
        widget.isMega
            ? const BurningIcon(burningType: 'mega')
            : const SizedBox(height: 30),
      ],
    );
  }

  Widget buildHeroImage() {
    return Column(
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
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  Widget buildCTAButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(
              width: 0,
              color: Theme.of(context).dividerColor,
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
        onPressed: () {},
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).primaryColor,
        ),
        label: Text(
          "Level " + widget.level.toString(),
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }

  Widget buildCardFlipIconButton() {
    return Transform.rotate(
      angle: -90 * pi / 180,
      child: IconButton(
        onPressed: () => _controller.toggleCard(),
        icon: const Icon(
          Icons.flip_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BurningIcon extends StatelessWidget {
  final String burningType;
  const BurningIcon({Key? key, required this.burningType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle style = Theme.of(context).textTheme.bodyMedium!.copyWith(
          color: Theme.of(context).dividerColor,
          fontSize: 11,
          fontWeight: FontWeight.w800,
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
    Color teraColor = Colors.red.shade600;
    Color megaColor = Colors.yellow.shade800;
    return Transform.scale(
      scale: 0.85,
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(top: 2, right: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).primaryColorDark,
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 2,
          ),
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
