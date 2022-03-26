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
        title: const Text("Character List"),
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
    );
  }
}
