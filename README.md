# プロジェクト名：『みどりのへや』
<img width="500" src="app/assets/images/ogp.png"><br>
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
ご自宅に飾られている観葉植物を投稿することができます。投稿された観葉植物は誰でも見られるようになり、気に入った写真があればブックマークに保存することができます。
<br>

# サービスURL
https://midorino-heya.onrender.com<br>
<br>

# サービス開発の経緯
大学時代は農学部に所属していて、現在も趣味として野菜や花を育てています。当初は家庭菜園の成長記録を共有できるアプリを考えていましたが、成長記録が完成するには最低でも1ヶ月はかかり、投稿のコストが高くなってしまいます。そこで、手軽に育てられる観葉植物を対象にすることで投稿のハードルを下げ、なおかつ育てることの楽しさを気軽に共有できると考えて開発しました。
<br>

# ターゲット層
 10代〜30代を対象にしています。
  第一園芸株式会社が2024年に発表した〜【三井不動産グループ 第一園芸調べ】観葉植物に関するアンケート調査結果〜によると、10代~20代の人が観葉植物を所有し始めて植物が好きになった人の割合が80%を超えたという結果が出ました。そこで、まだ観葉植物を持っていない人にも本サービスを通じて植物に興味を持ってもらいたいと考え、このターゲット層にしました。
<br>

出典：【三井不動産グループ 第一園芸調べ】観葉植物に関するアンケート調査結果 2024年 
https://www.daiichi-engei.jp/wp/wp-content/uploads/2024/08/a02e920d72a4b756a64774c28cd00675.pdf）


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

# キャッチアップ状況
Pl@ntNetを導入したように外部API連携の実装を経験しました。
<br>

## 画面遷移図
Figma:https://www.figma.com/design/FmEMws8ZvGzCD46H9HXjiW/Untitled?node-id=0-1&node-type=canvas&t=eHw0qZwD4sg8TSJb-0
<br>

## ER図
<img width="1246" height="924" alt="「みどりのへや」ER図" src="https://github.com/user-attachments/assets/35a68e99-6b17-4db0-af78-8cd6a66a850f" />

<br>
