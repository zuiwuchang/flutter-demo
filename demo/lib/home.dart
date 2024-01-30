import 'package:demo/animations/animations.dart';
import 'package:demo/language/language.dart';
import 'package:demo/language/s.dart';
import 'package:demo/listlink.dart';
import 'package:demo/theme/theme.dart';
import 'package:demo/tv/tv.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: <Widget>[
          ListLink(title: 'TV', builder: (_) => const MyTVPage()),
          ListLink(title: 'Theme', builder: (_) => const MyThemePage()),
          ListLink(title: 'Language', builder: (_) => const MyLanguagePage()),
          ListLink(
              title: 'Animations', builder: (_) => const MyAnimationsPage()),
        ],
      ),
    );
  }
}
