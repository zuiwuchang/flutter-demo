import 'package:demo/theme/settings.dart';
import 'package:flutter/material.dart';

class MyThemePage extends StatelessWidget {
  const MyThemePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final themes = Themes.instance;
    final supported = themes.supported;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Theme"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        stream: themes.stream,
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          return ListView.builder(
            itemCount: supported.length,
            itemBuilder: (context, i) {
              final value = supported[i];
              final checked = value == snapshot.data;
              return ListTile(
                leading: Icon(
                  checked ? Icons.check_circle : Icons.circle_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: Text(
                  supported[i],
                ),
                onTap: () => themes.value = value,
              );
            },
          );
        },
      ),
    );
  }
}
