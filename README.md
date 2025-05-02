# プロジェクト名：『緑の掲示板』
<img width="500" src="ogp.jpg"><br>
<br>

# 目次
- [サービス概要](#-サービス概要)
- [サービスURL](#-サービスurl)
- [サービス開発の経緯](#-サービス開発の経緯)
- [機能紹介](#-機能紹介)
- [技術構成について](#-技術構成について)
  - [使用技術](#使用技術)
  - [画面遷移図](#画面遷移図)
  - [ER図](#ER図)
<br>

# サービス概要
野菜、花、果樹などご家庭で育てている植物を、一つの観察日記が作成し、掲示板のように投稿することが出来ます。育てた実感をより感じてしていただく為に成長段階のテキストと画像挿入フォームを自由に追加できるようにしています。
<br>

# サービスURL
### https://www.midorino-keijiban.com/<br>
<br>

# サービス開発の経緯
大学時代は農学部に所属していて現在も家庭菜園を趣味として野菜や花を育てていました。その時市販で売られている育て方の本と実際に育てている環境とでは生育状況に遅れや生じたりすることも多々あります。そこでこのサービスを利用することで、同じ環境や条件での育成日記を見つけることで課題の改善することができる他、変わった育成方法も見つけることが可能で、家庭菜園の幅が広くなるのではないかと考え今回作ってみようと思いました。
<br>

# 機能紹介
| ユーザー登録 / ログイン |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/cb69e9b5a8189c573679418be7c5874f.png)](https://gyazo.com/cb69e9b5a8189c573679418be7c5874f)|
| <p align="left">『名前』『メールアドレス』『パスワード』『確認用パスワード』を入力してユーザー登録を行います。ユーザー登録後は、自動的にログイン処理が行われるようになっており、そのまま直ぐにサービスを利用する事が出来ます。</p> |
<br>

| 日記検索 / 日記一覧 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/5d6d9da8e88ccd8dfdfcbeddc0089b91.png)](https://gyazo.com/5d6d9da8e88ccd8dfdfcbeddc0089b91)|
| <p align="left">フリーキーワードから絞り出せる『タイトル』を初め５つのカテゴリーから日記を検索することが可能で、ユーザー登録の有無に関わらずどなたでも利用できます。</p> |
<br>

| 日記作成 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/5e53cdaad91f1eddde1e7807f67227c5.gif)](https://gyazo.com/5e53cdaad91f1eddde1e7807f67227c5)|
| <p align="left">日記の投稿には『タイトル』『概要』『植物名』の情報は必須です。追加ボタンを押すと、成長段階のテキストと画像挿入フォームを自由に追加、削除することができます。</p> |
<br>

| 日記の詳細を閲覧 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/3c09f5267da7798f75b7289b4cbe3414.png)](https://gyazo.com/3c09f5267da7798f75b7289b4cbe3414)|
| <p align="left">一覧画面から気になる日記をクリックすることで、大きな画像で見やすい成長段階を閲覧することができます。</p> |
<br>

| お問い合わせフォーム送信 |
| :---: | 
| [![Image from Gyazo](https://i.gyazo.com/2afc0ba0bc558235bd51d07cdc497e7f.png)](https://gyazo.com/2afc0ba0bc558235bd51d07cdc497e7f)|
| <p align="left">サービス利用時に発生した不具合を管理者に送信できるフォームを用意しています。このフォームは会員登録をしていないユーザーからも送信できます。</p> |
<br>

# 技術構成

## 使用技術
| カテゴリ | 技術内容 |
| --- | --- | 
| サーバーサイド | Ruby 3.1.4 Ruby on Rails 7.0.4|
| フロントエンド | Ruby on Rails・JavaScript |
| CSSフレームワーク | Bootstrap |
| データベースサーバー | PostgreSQL |
| ファイルサーバー | AWS S3 |
| アプリケーションサーバー | Heroku |
| バージョン管理ツール | GitHub・Git Flow |
<br>

## 画面遷移図
Figma:https://www.figma.com/design/FmEMws8ZvGzCD46H9HXjiW/Untitled?node-id=0-1&node-type=canvas&t=eHw0qZwD4sg8TSJb-0
<br>

## ER図
[![Image from Gyazo](https://i.gyazo.com/7ea966361619d459bf9ef57ba0f91b55.png)](https://gyazo.com/7ea966361619d459bf9ef57ba0f91b55)
<br>