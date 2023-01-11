import 'package:demo/tv/focusable.dart';
import 'package:flutter/material.dart';

class MySubmitPage extends StatefulWidget {
  const MySubmitPage({super.key});
  @override
  createState() => _MySubmitPageState();
}

class _MySubmitPageState extends State<MySubmitPage> {
  var _title = '';
  var _off = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("submit by $_title"),
        // 需要手動設置 leading，因爲默認的 BackButton 沒有適配 tv
        leading: FocusableWidget(
          child: BackButton(
            // 需要顯示指定 onPressed
            onPressed: () => Navigator.maybePop(context),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          FocusableWidget(
            child: ListTile(
              title: const Text('ListTile'),
              onTap: () => setState(() => _title = "ListTile"),
            ),
          ),
          FocusableWidget(
            child: TextButton(
              child: const Text('TextButton'),
              onPressed: () => setState(() => _title = "TextButton"),
            ),
          ),
          Row(
            children: [
              FocusableWidget(
                child: IconButton(
                  icon: const Icon(Icons.tv),
                  onPressed: _off
                      ? () => setState(() {
                            _title = "IconButton tv";
                            _off = false;
                          })
                      : null,
                ),
              ),
              FocusableWidget(
                child: IconButton(
                  icon: const Icon(Icons.tv_off),
                  onPressed: _off
                      ? null
                      : () => setState(() {
                            _title = "IconButton tv off";
                            _off = true;
                          }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
