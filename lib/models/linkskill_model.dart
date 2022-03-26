import 'package:flutter/material.dart';

class LinkSkill extends StatelessWidget {
  final String name = "Elementalism";
  final String job = "Kanna";
  final String desc =
      "Deepens your connection to the elements to provide a permanent damage increase.";
  final String bonusStat = "Damage";
  final List<int> bonusValues = [5, 10];
  final String bonusUnit = "%";
  final String imgurl = "./img/Elementalism.webp";
  late final int bonusValue;

  LinkSkill({
    Key? key,
    // required this.name,
    // required this.job,
    // required this.desc,
    // required this.bonusValues,
  }) : super(key: key) {
    bonusValue = calculateBonusValue();
  }
  int calculateBonusValue() {
    return bonusValues[1];
  }

  @override
  Widget build(BuildContext context) {
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
                        job,
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
}
