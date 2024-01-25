import 'package:demo/tv/focusable.dart';
import 'package:flutter/material.dart';

/// 模擬第三方組件
class MyTextButtonWidget extends StatelessWidget {
  const MyTextButtonWidget({
    super.key,
    required this.child,
    required this.onPressed,
  });
  final Widget child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: child);
  }
}

class MyListTileWidget extends StatelessWidget {
  const MyListTileWidget({
    super.key,
    required this.title,
    required this.onTap,
  });
  final Widget title;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      onTap: onTap,
    );
  }
}

/// 創建一個自定義的 FocusableWidget 的 包裝類，處理 FocusableWidget 不支持的第三方組件
class MyFocusableWidget extends StatelessWidget {
  const MyFocusableWidget({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FocusableWidget(
      onOK: _onOK, // 覆蓋 onOK 確認，onCancel 和 onMove 通常不需要處理
      // onCancel: ,
      // onMove: ,
      child: child,
    );
  }

  KeyEventResult _onOK(FocusNode focusNode, KeyEvent event) {
    if (focusNode.context?.widget == null) {
      return KeyEventResult.ignored;
    }
    // 獲取 被包裝的 子 widget
    var w = focusNode.context!.widget;
    if (w is Focus) {
      w = w.child;
    }
    // 查找提交函數
    VoidCallback? submit;
    if (w is MyTextButtonWidget) {
      submit = w.onPressed;
    } else if (w is MyListTileWidget) {
      submit = w.onTap;
    } else {
      // 沒有識別到組件 交給 系統繼續後續處理
      return KeyEventResult.ignored;
    }

    if (submit != null) {
      submit();
    }
    return KeyEventResult.handled;
  }
}

class MyExpandPage extends StatefulWidget {
  const MyExpandPage({super.key});
  @override
  createState() => _MyExpandPageState();
}

class _MyExpandPageState extends State<MyExpandPage> {
  var _title = '';
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
          MyFocusableWidget(
            child: MyListTileWidget(
              title: const Text('ListTile'),
              onTap: () => setState(() => _title = "ListTile"),
            ),
          ),
          MyFocusableWidget(
            child: MyTextButtonWidget(
              child: const Text('TextButton'),
              onPressed: () => setState(() => _title = "TextButton"),
            ),
          ),
        ],
      ),
    );
  }
}
