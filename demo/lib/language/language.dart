import 'package:demo/language/s.dart';
import 'package:demo/language/setting.dart';
import 'package:flutter/material.dart';

class MyLanguagePage extends StatelessWidget {
  const MyLanguagePage({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final languageSetting = LanguageSetting.instance;
    const supported = S.list;
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).languageChoose),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
        initialData: languageSetting.value,
        stream: languageSetting.stream,
        builder: (context, snapshot) {
          final theme = Theme.of(context);
          return ListView.builder(
            itemCount: supported.length + 1,
            itemBuilder: (context, i) {
              if (i == 0) {
                return ListTile(
                  leading: Icon(
                    snapshot.data == defaultLanguage
                        ? Icons.check_circle
                        : Icons.circle_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(S.of(context).languageSystem),
                  onTap: () => languageSetting.value = defaultLanguage,
                );
              }
              final value = supported[i - 1];
              final checked = value.id == snapshot.data;
              return ListTile(
                leading: Icon(
                  checked ? Icons.check_circle : Icons.circle_rounded,
                  color: theme.colorScheme.primary,
                ),
                title: Text(value.name),
                onTap: () => languageSetting.value = value.id,
              );
            },
          );
        },
      ),
    );
  }
}
