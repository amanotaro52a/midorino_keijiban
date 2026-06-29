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
| 植物名のオートコンプリート検索 |
| :---: | 
| <img width="600" height="302" alt="オートコンプリート動画gif" src="https://github.com/user-attachments/assets/7f9edf7c-0039-411f-a226-e41ab6c8a3db" />|
| <p align="left">『植物名』の検索欄にはオートコンプリート機能が備わっており、最初の一文字を入力するだけで、投稿されている植物名を割り出すことができます。(
未ログイン時でも使用できます。）</p> |
<br>

| 投稿画像の拡大表示 |
| :---: | 
| <img width="600" height="296" alt="画像ライトボックス" src="https://github.com/user-attachments/assets/a9fb45da-f224-49ea-8e7b-11c36346fbde" />|
| <p align="left">投稿詳細画面で表示されている画像をクリックすることで、ライトボックスでの画像拡大表示ができます。（投稿されているすべての画像が拡大できます。）</p> |
<br>

| 植物判定 |
| :---: | 
|<img width="600" height="306" alt="植物判定APIgif" src="https://github.com/user-attachments/assets/75503d9c-eaad-46d6-9649-ad4dca214a9a" />|
| <p align="left">万が一植物名を忘れてしまっても大丈夫です。添付した画像から植物判定APIを使えば割り出すことができます。（葉・茎など植物体が大きく写っていると認識がスムーズに行えます。）</p> |
<br>

# 技術構成
| カテゴリ | 技術内容 |
| --- | --- | 
| サーバーサイド | Ruby 3.1.4 / Ruby on Rails 7.0.4 |
| フロントエンド | Rails（Hotwire: Turbo / Stimulus）・JavaScript |
| CSSフレームワーク | Bootstrap 5|
| データベースサーバー | PostgreSQL |
| ファイルサーバー | AWS S3（CarrierWave + fog） |
| アプリケーションサーバー | Render |
| 外部API | 植物判別API（Pl@ntNet） |
| バージョン管理ツール | GitHub / Git Flow |
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
