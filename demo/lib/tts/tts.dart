import 'package:flutter/material.dart';

class MyTtsPage extends StatefulWidget {
  const MyTtsPage({
    super.key,
  });

  @override
  createState() => _MyTtsPageState();
}

class _MyTtsPageState extends State<MyTtsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TTS"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
    );
  }
}
