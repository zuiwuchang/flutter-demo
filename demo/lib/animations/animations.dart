import 'package:demo/animations/container_transform.dart';
import 'package:demo/animations/shared_axis_transition.dart';
import 'package:demo/listlink.dart';
import 'package:flutter/material.dart';

class MyAnimationsPage extends StatelessWidget {
  const MyAnimationsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Animations"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          ListLink(
            title: 'Container transform',
            builder: (context) => const MyContainerTransformPage(),
          ),
          ListLink(
            title: 'Shared axis',
            builder: (context) => const MySharedAxisTransitionPage(),
          )
        ],
      ),
    );
  }
}
