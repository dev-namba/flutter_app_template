# flutter_app_template

## 概要

Flutter + Firebase アプリの雛形

### 実装済み

- iOS13、Android7 以上
- DDD ライクな設計
- 状態管理は flutter_hooks、riverpod を利用
- Firebase を利用 (FirebaseAuth, Firestore, Functions, FirebaseAnalytics, FirebaseCrashlytics)
- タブ構成のサンプル画面実装
- iOS カメラ、画像のパーミッション許可の plist 設定
- その他アプリに必要なライブラリを設定済み
- デバイス向きは縦固定
- 起動時に匿名認証でログイン

### やっていないこと

- Android/iOS の Flavor 設定
- Android/iOS ローカル通知とプッシュ通知の設定
- Android の keystore の設定（debug, release）
- iPad 対応

## 設計指針

[こちらの資料](https://docs.google.com/presentation/d/19XERQBG-aWWD7R5NEJCyS8VXSeUL9KTENOe0ChYz_1M)にまとめました。

## 新規プロジェクトへの移行方法

1. git clone で取り込む

```
git clone https://github.com/hukusuke1007/flutter_app_template.git
```

2. 取り込んだら .git を削除する

```
rm -rf .git
```

3. 以下の箇所を変更後のプロジェクト名へ変更。com.example.app から変更したいプロジェクト名にする
   https://github.com/hukusuke1007/flutter_app_template/pull/1/files

4. 新しい Firebase プロジェクトを作成して Firebase の 設定ファイル を変更する。Firebase については[こちら](https://firebase.flutter.dev/docs/overview)を確認してください。新しい Firebase プロジェクトを作成後、.json と.plist ファイルを以下のものと入れ替える。

```
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

3. 利用する Firebase コンソールから匿名認証を ON にする

4. pub get をしてライブラリを取り込む。pubspec.lock 内のプラグインのバージョンを見て pubspec.yaml のプラグインのバージョンを指定する（利用するバージョンを固定にするため）

5. ビルドして動作確認する

6. 問題なければ新しい git repository を作成して本プロジェクトをプッシュする。