import 'package:demo/tv/focusable.dart';
import 'package:demo/tv/tv.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _tv() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MyTVPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Demo"),
      ),
      body: ListView(
        children: <Widget>[
          FocusableWidget(
            child: ListTile(
              title: const Text('TV'),
              onTap: _tv,
            ),
          ),
        ],
      ),
    );
  }
}
