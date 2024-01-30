import 'package:animations/animations.dart';
import 'package:demo/tv/focusable.dart';
import 'package:flutter/material.dart';

class _Message {
  final int id;
  String title;
  String text;
  _Message({
    required this.id,
    required this.title,
    required this.text,
  });
}

class MyContainerTransformPage extends StatefulWidget {
  const MyContainerTransformPage({
    super.key,
  });
  @override
  createState() => _MyContainerTransformPageState();
}

class _MyContainerTransformPageState extends State<MyContainerTransformPage> {
  // 模擬 100 條消息
  final _list = List.generate(
          100,
          (index) =>
              _Message(id: index, title: 'title $index', text: 'text $index'))
      .toList();

  final focusClosed = FocusNode();
  @override
  void dispose() {
    focusClosed.dispose();
    super.dispose();
  }

  FocusNode? _focus;
  bool _unPrimaryFocus(FocusNode node) {
    for (var child in node.children) {
      if (!child.hasFocus) {
        continue;
      } else if (child.hasPrimaryFocus) {
        child.unfocus();
        _focus = child;
        return true;
      } else if (_unPrimaryFocus(child)) {
        return true;
      }
    }
    return false;
  }

  void _restoreFocus() {
    final focus = _focus!;
    if (focus.canRequestFocus) {
      focus.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Container transform"),
        backgroundColor: colorScheme.inversePrimary,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => OpenContainer<bool>(
          // 設置不可點擊，只能調用 action 來打開視圖，默認爲 true
          tappable: false,
          // 響應關閉回調
          onClosed: (returnValue) {
            // 恢復 closed 焦點，可能會引起焦點 ui 閃爍，如果要避免閃爍可以選擇不進行恢復
            if (_focus != null) {
              _restoreFocus();
            }

            if (returnValue ?? false) {
              setState(() {
                _list.removeAt(index);
              });
            }
          },
          // 設置視圖背景色和主題一致
          closedColor: colorScheme.surface,
          openColor: colorScheme.surface,
          // 關閉時 視圖
          closedBuilder: (context, action) => Focus(
            focusNode: focusClosed,
            child: _ClosedWidget(
              action: () {
                // 打開視圖前先讓 closed view 失去焦點，否則無法使用遙控器或鍵盤在新視圖中移動焦點
                _focus = null;
                if (focusClosed.hasFocus) {
                  if (!_unPrimaryFocus(focusClosed)) {
                    focusClosed.unfocus();
                  }
                }
                // 打開視圖
                action();
              }, // 可以調用 action 打開視圖
              message: _list[index],
            ),
          ),
          // 打開後視圖
          openBuilder: (context, action) => _OpenWidget(
            action: action, // 可以調用 action 關閉視圖
            message: _list[index],
          ),
        ),
        itemCount: _list.length,
      ),
    );
  }
}

class _ClosedWidget extends StatelessWidget {
  const _ClosedWidget({
    required this.action,
    required this.message,
  });
  final VoidCallback action;
  final _Message message;
  @override
  Widget build(BuildContext context) {
    return FocusableWidget(
      // focusNode: focusNode,
      child: ListTile(
        leading: const Icon(Icons.message),
        title: Text(message.title),
        // 可以直接使用 ListTile 也不用設置 onTap，但這樣 tv 無法受控
        onTap: action,
      ),
    );
  }
}

class _OpenWidget extends StatefulWidget {
  const _OpenWidget({
    required this.action,
    required this.message,
  });
  final CloseContainerActionCallback<bool> action;
  final _Message message;
  @override
  createState() => _OpenWidgetState();
}

class _OpenWidgetState extends State<_OpenWidget> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final child = Scaffold(
      appBar: AppBar(
        title: Text(widget.message.title),
        backgroundColor: colorScheme.inversePrimary,
        // 需要手動設置 leading，因爲默認的 BackButton 沒有適配 tv
        leading: FocusableWidget(
          child: BackButton(
            // 需要顯示指定 onPressed
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          FocusableWidget(
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                // 調用 action 或者 Navigator.pop 關閉視圖並返回數據
                widget.action(returnValue: true);
                // Navigator.of(context).pop(true);
              },
              tooltip: '刪除消息',
            ),
          )
        ],
      ),
      body: ListView(children: [
        Wrap(
          children: [Text(widget.message.text)],
        ),
      ]),
    );
    return child;
  }
}
