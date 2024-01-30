import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class MyTtsPage extends StatefulWidget {
  const MyTtsPage({
    super.key,
  });

  @override
  createState() => _MyTtsPageState();
}

class _MyTtsPageState extends State<MyTtsPage> {
  late FlutterTts _flutterTts;
  @override
  void initState() {
    super.initState();
    _flutterTts = FlutterTts();

    _flutterTts.getEngines.then((value) {
      debugPrint("${value.runtimeType}");
    });
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

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
