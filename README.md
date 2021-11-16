## pexels-photo-searcher

### 動作確認手順
1. リポジトリをクローンしてライブラリをインストール

httpsでクローンする場合
```
$ git clone https://github.com/yskmyt/pexels-photo-searcher.git
$ cd pexels-photo-searcher
$ pod install
```
※ Apple Silicon Mac で `pod install` が失敗してしまう場合下記を実行してみてください
```
$ sudo arch -x86_64 gem install ffi
$ arch -x86_64 pod install
```

2. Xcodeを開いてRun

#### 対応OS
- iOS12.1以上

### 使用ライブラリ
- [RxSwift](https://github.com/ReactiveX/RxSwift)
