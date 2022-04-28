import 'package:flutter/material.dart';

class LinkSkill extends StatelessWidget {
  final String name;
  final String job;
  final String desc;
  final int rating;
  final List<LinkBonus> bonuses;
  late final String imgurl;
  late final int masterLevel;

  LinkSkill({
    Key? key,
    required this.name,
    required this.job,
    required this.desc,
    required this.rating,
    required this.bonuses,
  }) : super(key: key) {
    imgurl = parseImageURL();
    masterLevel = bonuses[0].values.length;
  }

  factory LinkSkill.fromMap(Map<String, dynamic> linkMap) {
    final name = linkMap['name'] as String;
    final job = linkMap['job'] as String;
    final desc = linkMap['desc'] as String;
    final rating = linkMap['rating'] as int;
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
      rating: rating,
      bonuses: linkList,
    );
  }

  String parseImageURL() {
    String url = "assets/img/" + name.replaceAll(' ', '') + ".webp";
    return url;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle fs = Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 12,
        );
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: List.generate(5, (i) {
              return Icon(
                (i < rating) ? Icons.star : Icons.star_border,
                color: Colors.yellow.shade400,
              );
            }).toList(),
          ),
        ),
        Container(
          constraints: const BoxConstraints(maxHeight: 100),
          child: Card(
            child: SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Master Level: " + masterLevel.toString()),
                    ...(bonuses.map((b) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(b.stat, style: fs),
                          Table(
                            defaultColumnWidth: const FixedColumnWidth(40),
                            border: TableBorder.symmetric(
                              inside: const BorderSide(),
                            ),
                            children: [
                              TableRow(
                                children: b.values
                                    .asMap()
                                    .map((i, v) {
                                      MapEntry<int, Text> m =
                                          const MapEntry(0, Text("..."));
                                      if (b.values.length - i < 6) {
                                        m = MapEntry(
                                          i,
                                          Text(
                                            v.toString() + b.unit,
                                            style: fs,
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }
                                      return m;
                                    })
                                    .values
                                    .toList(),
                              )
                            ],
                          ),
                        ],
                      );
                    }).toList()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  // Map<String, dynamic> toMap() {

  // }

  // @override
  // String toString() {

  // }

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
