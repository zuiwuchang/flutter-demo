# animations

animations 是 flutter 官方提供的一些轉過渡畫特效

```
flutter pub add animations
```

animations 提供了下述四種過渡動畫

1. [Container transform](#container-transform )
2. [Shared axis](#shared-axis)
3. [Fade through](#Fadethrough)
4. [Fade](#Fade)


# Container transform 

Container transform 專為包含容器的 UI 元素之間的轉換而設計。 此模式在兩個 UI 元素之間建立可見的連接(縮放特效)。

![](container_transform_lineup.gif)

容器變換的範例：

* 一張卡片進入詳情頁
* 清單項目進入詳細資訊頁面
* FAB 進入詳細資料頁面
* 擴展搜尋的搜尋欄

它的使用方式是使用 OpenContainer 創建 Widget，在 closedBuilder 屬性中創建原始的簡略視圖，在 openBuilder 屬性中創建關聯的展開視圖

**container_transform.dart** 中包含了一個例子

# Shared axis

Shared axis 用於具有空間或導航關係的 UI 元素之間的過渡。 此模式使用 x、y 或 z 軸上的共享變換來加強元素之間的關係。

![](shared_axis_lineup.gif)

共享軸模式的範例：

* 引導流程沿著 x 軸過渡
* 步進器沿 y 軸過渡
* 父子導航沿 z 軸過渡

它的使用方式是使用 PageTransitionSwitcher 創建 Widget，並設置 child 屬性爲當前要顯示的頁面，在 transitionBuilder 屬性中創建 SharedAxisTransition 來設置特效效果

**shared_axis_transition.dart** 中包含了一個例子