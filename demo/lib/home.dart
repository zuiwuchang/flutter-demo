import 'package:demo/language/language.dart';
import 'package:demo/language/s.dart';
import 'package:demo/theme/theme.dart';
import 'package:demo/tts/tts.dart';
import 'package:demo/tv/focusable.dart';
import 'package:demo/tv/tv.dart';
import 'package:flutter/material.dart';

class _ListLink extends StatelessWidget {
  const _ListLink({
    required this.title,
    required this.builder,
  });
  final String title;
  final WidgetBuilder builder;
  @override
  Widget build(BuildContext context) => FocusableWidget(
        child: ListTile(
          title: Text(title),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: builder,
            ),
          ),
        ),
      );
}

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
          _ListLink(title: 'TV', builder: (_) => const MyTVPage()),
          _ListLink(title: 'Theme', builder: (_) => const MyThemePage()),
          _ListLink(title: 'Language', builder: (_) => const MyLanguagePage()),
          _ListLink(title: 'TTS', builder: (_) => const MyTtsPage()),
        ],
      ),
    );
  }
}
