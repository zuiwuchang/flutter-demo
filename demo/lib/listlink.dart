import 'package:demo/tv/focusable.dart';
import 'package:flutter/material.dart';

class ListLink extends StatelessWidget {
  const ListLink({
    super.key,
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
