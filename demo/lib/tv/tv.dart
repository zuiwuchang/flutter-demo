// ignore_for_file: sort_child_properties_last

import 'package:demo/tv/expand.dart';
import 'package:demo/tv/focusable.dart';
import 'package:demo/tv/submit.dart';
import 'package:flutter/material.dart';

class MyTVPage extends StatefulWidget {
  const MyTVPage({
    super.key,
  });
  @override
  createState() => _MyTVPageState();
}

class _MyTVPageState extends State<MyTVPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TV"),
        leading: FocusableWidget(
          child: BackButton(
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FocusableWidget(
            child: ListTile(
              title: const Text("flutter 系統組件"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MySubmitPage(),
                ),
              ),
            ),
          ),
          FocusableWidget(
            child: ListTile(
              title: const Text("自定義組件"),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MyExpandPage(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
