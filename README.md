# LSPlayPauseButton

## English
### Overview
This project is a swift version of [XLPlayButton](https://github.com/mengxianliang/XLPlayButton) thanks for [XianLiang Meng](https://github.com/mengxianliang)

The play&pause button include style of [iQiYi](http://www.iqiyi.com) and [YouKu](http://www.youku.com)

### Usage
The LSPlayPauseButton is a sub class of UIButton, you can use the normal initiate method:

```swift
let button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60), style: .youku, state: .play)
```

You can also use lazy init method

```swift
let button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
```

The lazy version use style of iQiYi as default style and pause state as the default state of the button. (You must expicity init the frame since the animation will use the frame size)

You change the button's state use the *buttonState* property change the state of the button

```swift
button.buttonState = .play
```

or

```swift
button.buttonState = .pause
```

### Others
I'll add Cocoapods support later, please keep following of new version.

## 中文
### 简介
这是一个使用Swift重写的 [XLPlayButton](https://github.com/mengxianliang/XLPlayButton)， 感谢[XianLiang Meng](https://github.com/mengxianliang)

LSPlayPauseButton包含了[爱奇艺](http://www.iqiyi.com)和[优酷](http://www.youku.com)两种国内常见的播放暂停按钮的app端动画展示
### 使用方法
LSPlayPauseButton继承自UIKit的UIButton类，你可以使用完整初始化方法

```swift
let button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60), style: .youku, state: .play)
```

你也可以使用如下的简单初始化方法

```swift
let button = LSPlayPauseButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
```

简单初始化方法以爱奇艺的样式为默认样式，以暂停状态为按钮的初始状态（初始化必须设置正确的frame参数，这是因为播放暂停按钮的动画需要根据frame的尺寸来进行设置）

使用对象的*buttonState*属性来对按钮的状态进行更改

```swift
button.buttonState = .play
```

或者

```swift
button.buttonState = .pause
```
### 其他
后续会添加Cocoapods的支持，敬请关注
