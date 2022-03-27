import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:legionprovider/models/character_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _characters = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('character.json');
    final data = await json.decode(response);
    setState(() {
      _characters = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    readJson();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Character List",
          style: Theme.of(context).textTheme.headline5!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
      body: _characters.isEmpty
          ? const RefreshProgressIndicator(
              value: null,
            )
          : ListView.builder(
              itemCount: _characters.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> c = _characters[index];
                return Column(
                  children: [
                    Character.fromMap(c),
                    if (index < _characters.length - 1)
                      const SizedBox(height: 24),
                  ],
                );
              },
            ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.local_fire_department,
          color: Theme.of(context).cardColor,
        ),
        onPressed: () {},
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
              onPressed: () {},
              icon: const Icon(Icons.search),
              color: Theme.of(context).secondaryHeaderColor,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.menu),
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ],
        ),
      ),
    );
  }
}
