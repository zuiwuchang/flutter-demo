// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef FocusableOnMove = KeyEventResult Function(
    FocusNode focusNode, KeyEvent event, TraversalDirection traversalDirection);
typedef FocusableOnOK = KeyEventResult Function(
    FocusNode focusNode, KeyEvent event);
typedef FocusableOnCancel = FocusableOnOK;

typedef FocusBuilderCallback = Widget Function(
    BuildContext context, FocusNode focusNode);

class FocusableWidget extends StatefulWidget {
  const FocusableWidget({
    super.key,
    required this.child,
    this.focusNode,
    this.onKeyEvent,
    this.onMove,
    this.onOK,
    this.onCancel,
  });

  /// 被包裝的 Widget
  final Widget child;
  final FocusNode? focusNode;

  /// 可以攔截默認的 按鍵處理
  final FocusOnKeyEventCallback? onKeyEvent;

  /// 可以攔截默認的 焦點移動 處理
  final FocusableOnMove? onMove;

  /// 可以攔截默認的 確認 處理
  final FocusableOnOK? onOK;

  /// 可以攔截默認的 取消 處理
  final FocusableOnCancel? onCancel;
  @override
  createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  FocusNode? _focusNode;

  /// 如果 widget 沒設置 FocusNode 就創建一個
  FocusNode get focusNode {
    if (widget.focusNode != null) {
      return widget.focusNode!;
    }
    return _focusNode ??= FocusNode();
  }

  @override
  void dispose() {
    /// 釋放自動創建的 FocusNode
    _focusNode?.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode focusNode, KeyEvent event) {
    /// 首先調用 傳入的 攔截器
    if (widget.onKeyEvent != null) {
      final result = widget.onKeyEvent!(focusNode, event);
      if (result != KeyEventResult.ignored) {
        return result;
      }
    }

    if (event is KeyDownEvent) {
      // tv 遙控器 移動 焦點
      // 鍵盤 方向鍵
      if (LogicalKeyboardKey.arrowLeft == event.logicalKey) {
        return _moveArrow(focusNode, event, TraversalDirection.left);
      } else if (LogicalKeyboardKey.arrowRight == event.logicalKey) {
        return _moveArrow(focusNode, event, TraversalDirection.right);
      } else if (LogicalKeyboardKey.arrowUp == event.logicalKey) {
        return _moveArrow(focusNode, event, TraversalDirection.up);
      } else if (LogicalKeyboardKey.arrowDown == event.logicalKey) {
        return _moveArrow(focusNode, event, TraversalDirection.down);
      }
    } else if (event is KeyUpEvent) {
      // tv 遙控器 select
      // 鍵盤 enter
      if (LogicalKeyboardKey.select == event.logicalKey ||
          LogicalKeyboardKey.enter == event.logicalKey) {
        final result = _ok(focusNode, event);
        if (result != KeyEventResult.ignored) {
          return result;
        }
      }
      // tv 遙控器 cancel
      // 鍵盤 esc
      else if (LogicalKeyboardKey.cancel == event.logicalKey ||
          LogicalKeyboardKey.escape == event.logicalKey) {
        final result = _cancel(focusNode, event);
        if (result != KeyEventResult.ignored) {
          return result;
        }
      }
    }
    return KeyEventResult.ignored;
  }

  KeyEventResult _moveArrow(
      FocusNode node, KeyEvent event, TraversalDirection direction) {
    if (widget.onMove != null) {
      final result = widget.onMove!(node, event, direction);
      if (result != KeyEventResult.ignored) {
        return result;
      }
    }
    node.focusInDirection(direction);
    return KeyEventResult.handled;
  }

  KeyEventResult _ok(FocusNode node, KeyEvent event) {
    if (widget.onOK != null) {
      final result = widget.onOK!(node, event);
      if (result != KeyEventResult.ignored) {
        return result;
      }
    }

    if (node.context?.widget == null) {
      return KeyEventResult.ignored;
    }

    VoidCallback? submit;
    var w = node.context!.widget;
    if (w is Focus) {
      w = w.child;
    }

    /// 處理 系統提供的 常用 widget
    if (w is ListTile) {
      submit = w.onTap;
    } else if (w is GestureDetector) {
      submit = w.onTap;
    } else if (w is InkResponse) {
      submit = w.onTap;
    } else if (w is ButtonStyleButton) {
      // TextButton
      submit = w.onPressed;
    } else if (w is IconButton) {
      submit = w.onPressed;
    } else if (w is CloseButton) {
      submit = w.onPressed;
    } else if (w is BackButton) {
      submit = w.onPressed;
    } else {
      return KeyEventResult.ignored;
    }
    if (submit != null) {
      submit();
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _cancel(FocusNode node, KeyEvent event) {
    if (widget.onCancel != null) {
      final result = widget.onCancel!(node, event);
      if (result != KeyEventResult.ignored) {
        return result;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    /// 使用 Focus 進行包裝 以便接管鍵盤處理
    return Focus(
      child: widget.child,
      onFocusChange: ((ok) {
        if (!ok) {
          return;
        }
        var node = focusNode;
        if (!node.hasPrimaryFocus) {
          return;
        }

        /// 如果獲取到焦點並有主焦點，將主焦點設置到第一個找到的子焦點(即 被包裝的 widget)
        /// 因爲 flutter 提供的 widget 很多要獲取到主焦點才會額外繪製焦點效果
        for (var child in node.children) {
          if (child.canRequestFocus) {
            child.requestFocus();
            break;
          }
        }
      }),
      focusNode: focusNode,
      onKeyEvent: _onKeyEvent,
    );
  }
}
