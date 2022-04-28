// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:math';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:legionprovider/models/legioneffect_model.dart';
import 'package:legionprovider/models/linkskill_model.dart';
import 'package:legionprovider/models/utilities.dart';

class Character extends StateNotifier<String> {
  final String name;
  final String? shortName;
  final int level;
  late final String _imgurl;
  final String pcolor;
  final String scolor;
  final bool isTera;
  final bool isMega;
  final LinkSkill linkSkill;
  final Map<String, dynamic> mapData;

  Character({
    Key? key,
    required this.name,
    required this.shortName,
    required this.level,
    required this.linkSkill,
    required this.mapData,
    this.pcolor = "#ffffff",
    this.scolor = "#000000",
    this.isMega = false,
    this.isTera = false,
  }) : super('') {
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
      mapData: other.mapData,
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
      mapData: data,
    );
  }

  String parseImgURL() {
    String url = "assets/img/" + name.replaceAll(' ', '') + ".webp";
    return url;
  }
}

class CharacterCard extends ConsumerWidget {
  final Character char;
  const CharacterCard({Key? key, required this.char}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = min(size.width, 600.0);
    final height = min(width / 2.5, 600.0);
    return Container(
      constraints: const BoxConstraints(maxWidth: 600, minHeight: 205),
      child: FlipCard(
        flipOnTouch: true,
        direction: FlipDirection.VERTICAL,
        front: CharacterCardFrontSide(
          char: char,
        ),
        back: SizedBox(
          height: height,
          child: GradientBackground(
            char: char,
            child: Stack(
              children: [
                CharacterInfoTitleBar(title: char.linkSkill.name),
                char.linkSkill,
                HeroImage(char: char, option: 'link'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GradientBackground extends ConsumerWidget {
  final Character char;
  final Widget child;
  const GradientBackground({Key? key, required this.char, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      key: const ValueKey(true),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Utilities.hexToColor(char.pcolor),
            Utilities.hexToColor(char.scolor),
          ],
          transform: const GradientRotation(135 * pi / 180),
        ),
      ),
      constraints: const BoxConstraints(maxHeight: 205),
      padding: const EdgeInsets.all(4),
      child: child,
    );
  }
}

class CharacterCardFrontSide extends ConsumerWidget {
  final Character char;
  const CharacterCardFrontSide({Key? key, required this.char})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      char: char,
      child: Stack(
        children: [
          CharacterInfoWidget(char: char),
          HeroImage(char: char, option: "legion"),
        ],
      ),
    );
  }
}

class CharacterInfoWidget extends ConsumerWidget {
  final Character char;
  const CharacterInfoWidget({Key? key, required this.char}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String cardTitle =
        (char.shortName != null) ? char.shortName.toString() : char.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CharacterInfoTitleBar(title: cardTitle),
            CharacterCardStatusBar(char: char),
          ],
        ),
        const Spacer(),
        CharacterCardCTAButton(char: char),
        LegionEffect.fromMap(char.mapData),
      ],
    );
  }
}

class CharacterInfoTitleBar extends ConsumerWidget {
  final String title;
  const CharacterInfoTitleBar({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
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
          const CardFlipIconButton(),
        ],
      ),
    );
  }
}

class CharacterCardStatusBar extends ConsumerWidget {
  final Character char;
  const CharacterCardStatusBar({Key? key, required this.char})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        char.isTera
            ? const BurningIcon(burningType: 'tera')
            : const SizedBox(height: 30),
        char.isMega
            ? const BurningIcon(burningType: 'mega')
            : const SizedBox(height: 30),
      ],
    );
  }
}

class CharacterCardCTAButton extends ConsumerWidget {
  final Character char;
  const CharacterCardCTAButton({Key? key, required this.char})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          "Level ${char.level.toString()}",
          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}

class HeroImage extends ConsumerWidget {
  final Character char;
  final String option;
  const HeroImage({Key? key, required this.char, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget img = Container();
    if (option == "legion") {
      img = Column(
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
                  image: AssetImage(char._imgurl),
                  height: 210,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      );
    } else if (option == "link") {
      img = Align(
        alignment: const Alignment(0.95, -0.1),
        child: Image(
          image: AssetImage(char.linkSkill.imgurl),
          height: 50,
          fit: BoxFit.fill,
        ),
      );
    }
    return img;
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

class CardFlipIconButton extends ConsumerWidget {
  const CardFlipIconButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controllerNotifier = ref.watch(flipControllerProvider.notifier);
    return Transform.rotate(
      angle: -90 * pi / 180,
      child: const Icon(
        Icons.flip_outlined,
        color: Colors.white,
      ),
    );
  }
}

// final flipControllerProvider = StateNotifierProvider((_) {
//   final FlipCardController _controller = FlipCardController();
//   return FlipCardControllerProvider(_controller);
// });

// final currentFlipController =
//     Provider((ref) => ref.watch(flipControllerProvider));

// class FlipCardControllerProvider extends StateNotifier<FlipCardController> {
//   FlipCardControllerProvider(FlipCardController state) : super(state);

//   void toggleFlip() {
//     state.toggleCard();
//   }
// }
