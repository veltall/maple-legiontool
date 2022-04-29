// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:legionprovider/models/character_model.dart';
import 'package:legionprovider/providers/legion_provider.dart';
import 'filter_selection_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/character.json');
    final data = await json.decode(response);

    setState(() {
      ref.read(characterListProvider.state).state = [...data];
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    final charList = ref.watch(filteredCharacterListProvider);
    final legionLevel = ref.watch(legionLevelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Legion Level: " + legionLevel.toString(),
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: charList.isEmpty
          ? const RefreshProgressIndicator(
              value: null,
            )
          : ListView.builder(
              itemCount: charList.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> c = charList[index];
                return Column(
                  children: [
                    CharacterCard(char: Character.fromMap(c)),
                    if (index < charList.length - 1) const Divider(height: 2),
                  ],
                );
              },
            ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.local_fire_department,
          color: Theme.of(context).colorScheme.primary,
        ),
        onPressed: initState,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      extendBody: true,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Theme.of(context).colorScheme.primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/filter');
              },
              icon: const Icon(Icons.filter_alt),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
