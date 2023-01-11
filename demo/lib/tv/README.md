# tv

這是一個使用 flutter 爲 android tv 編寫程式的方案，apple tv
應該也能使用類似方案但本喵沒有 apple 設備所以無法確認！

# 遙控器

tv
設備無法觸屏通常也沒有鼠標鍵盤，唯一通用的控制方式是遙控器。通常不同的遙控器帶有很多按鍵，但額外的按鍵包含哪些是無法確認的故無法對它們進行有效的編程。

能夠有效進行編程的按鍵只有6個，分別是遙控器的 上下左右 四個方向鍵，以及 確認鍵
和 取消鍵。

所以通常我們應該使用 上下左右 四個按鍵來移動焦點，然後通過 確認鍵 和 取消鍵
來使用焦點組件提供的功能或取消功能。(複雜的功能可以將其放到不同的焦點 widget
上，然後移動焦點來選取功能)。

| 遙控器按鈕 | flutter logicalKey |
| ---------- | ------------------ |
| 上         | arrowUp            |
| 下         | arrowDown          |
| 左         | arrowLeft          |
| 右         | arrowRight         |
| 確認       | select             |
| 取消       | cancel             |

# 焦點

flutter 可以通過 Focus 來控制焦點，其 onKeyEvent 回調函數可以用於處理按鍵事件

所以只要使用 Focus 並實現一個比較通用的 onKeyEvent 函數來處理 焦點移動 確認 取消
就能很好的對 tv 進行編程

focusable.dart 中的 FocusableWidget 就是來完成這件事的

# FocusableWidget

FocusableWidget 定義在 focusable.dart 中，它是本系統用於處理遙控器按鍵的 Widget

只需要將 flutter 提供的原始 widget 作爲 child 給 FocusableWidget
進行包裝，FocusableWidget 就會接管對焦點的處理以支持 tv

FocusableWidget 提供了幾個可選的回調函數，設置它們可以修改對焦點的處理方案

```
final FocusOnKeyEventCallback? onKeyEvent;
final FocusableOnMove? onMove;
final FocusableOnOK? onOK;
final FocusableOnCancel? onCancel;
```

- onKeyEvent 是最先被調用可以對最原始的鍵盤事件就行處理
- onMove 是在解析到遙控器和鼠標 上下左右 按鍵被按下時的回調，通常在此移動焦點
- onOK 是在遙控器 ok 被擡起時回調，通常在此調用 子組件的 提交功能例如
  (GestureDetector.onTap 或 TextButton.onPressed)
- onCancel 是在遙控器 cancel 被擡起時回調，通常在此 取消功能(例如 退出頁面 或者
  關閉選單)

# example

- submit.dart 演示了使用 FocusableWidget 和 flutter 默認組件如何一起工作
- expand.dart 演示了使用 FocusableWidget 和 自定義/第三方 組件如何一起工作
