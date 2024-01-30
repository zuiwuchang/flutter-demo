# animations

animations 是 flutter 官方提供的一些轉過渡畫特效

```
flutter pub add animations
```

animations 提供了下述四種過渡動畫

1. [Container transform](#Containertransform )
2. [Shared axis](#Sharedaxis)
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