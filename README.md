# 人事評価のための社内SNS・Busrep
## 概要
ポートフォリオ。  
人事評価のための社内SNS・Busrep。このシステムはブロックチェーンと電子署名により信頼性の高い投稿・閲覧機能を提供します。

Busrep は見られるではなく「魅せること」に重点をおいた能動的な人事評価を可能にします。  
Busrep は以下の 3 つの悪意を防ぐことにより情報の信頼性を確保します。  

- なりすまし : 電子署名を連鎖させることでなりすましを防ぐ

- 改ざん     : ブロックチェーンの構造を利用することで改ざんを防ぐ

- 偽証       : 人の目で偽証を防ぐ


## 機能
このプログラムはサーバとクライアントのふたつのプログラムで構成されています。  
サーバはデータベースの操作とデータ処理のためのWebAPIを提供します。  
クライアントはモバイルアプリで登録、投稿、閲覧の操作を行います。  

## 機能(サーバ)
サーバは以下のWebAPIを提供します。  
register     : クライアントから登録データを受け取り、登録データからブロックを生成します。生成したブロックをブロックチェーンに組み込んだあと、登録データを保存します。  
post         : クライアントから投稿データを受け取り、投稿データからブロックを生成します。生成したブロックをブロックチェーンに組み込んだあと、投稿データを保存します。  
view         : クライアントが閲覧のためにブロックチェーンに保存された電子署名を照合するとき、クライアントが要求する投稿・ユーザのデータを返します。   
update       : クライアントがブロックチェーンを更新するためにユーザが保持するよりも新しいブロックチェーンを返します。  
user_id_list : クライアントが登録するときに既に使われているユーザIDのリストを返します。新しいユーザIDの生成はクライントが行うので、この返し値には信頼性がありません。  

## 機能(クライアント)
クライアントのプログラムには以下の 3 つの機能が実装されています。  
-登録  
-投稿  
-閲覧  

### 登録
サーバのアドレス・ユーザ名・パスワードを登録する。  
登録データをもとに電子署名を作って、登録データとともにサーバに送信する。
<img src="https://user-images.githubusercontent.com/62014389/122200483-0ceb4300-ced6-11eb-84d5-ee682c695a15.jpg" width="320px">
<img src="https://user-images.githubusercontent.com/62014389/122200580-23919a00-ced6-11eb-956f-f358ab8f9fba.jpg" width="320px">

### 投稿
投稿する。  
投稿データをもとに電子署名を作って、投稿データとともにサーバに送信する。
<img src="https://user-images.githubusercontent.com/62014389/122200687-3c01b480-ced6-11eb-88d5-2225fe1ab1ee.jpg" width="320px">

### 閲覧
投稿を閲覧する。  
ユーザID,ユーザ名,投稿内容,投稿日時の順で表示されている。
サーバから受け取った投稿データ,ブロックチェーンにはユーザIDは含まれていない。
そのため保持するブロックチェーンを更新した後、サーバに投稿データを要求。投稿データと保持するブロックチェーンを用いて、照合と投稿者の特定を行う。  
なりすましができないことを示すために、投稿者ごとに固有の色で表示される。
例えば,ユーザ名がUSER 1であれば、ユーザIDが異なるので色が違っている。
<img src="https://user-images.githubusercontent.com/62014389/122200761-4d4ac100-ced6-11eb-9b67-2b91038e54b8.jpg" width="320px">

### データベース
サーバ:MariaDB  
 user(id,user_id,username,public_key,next_public_key)  
 post(post_id,content,public_key,next_public_key)  
 blockchain(block_id,action,action_id,digital_signature,created,previous_hash)  
 
クライアント:SQLite  
 user(id,user_id,name,public_key)  
 my_post(post_id,content,public_key,next_public_key)  
 blockchain(block_id,action,action_id,digital_signature,created,previous_hash,user_id)  

## 仕組み
## アルゴリズム
## ブロックチェーンの構造
![Slide1](https://user-images.githubusercontent.com/62014389/122200960-7d925f80-ced6-11eb-95bc-a8473fedff7e.jpg)
ブロックチェーンのピンポイントで改ざんできないという性質を利用しています。  
チェーンの更新では新しい部分のみを取得するため、改ざんするには過半数の端末のブロックチェーンを改ざんする必要があります。

## 電子署名
![Slide2](https://user-images.githubusercontent.com/62014389/122200992-884cf480-ced6-11eb-86c8-813f6ee737c5.jpg)
Private Key A(秘密鍵)でData1をメッセージとする電子署名を作成します。この電子署名はPublic Key A(公開鍵)によってのみ照合されます。  
Public Key AからPrivate Key Aを推定することは非常に困難です。

## 連鎖する電子署名
![Slide3](https://user-images.githubusercontent.com/62014389/122201049-96027a00-ced6-11eb-9107-8fddfd2e26ce.jpg)
現在の投稿に次の投稿で使うPublic Keyを含むことで連鎖的に鍵の持ち主が判明します。

## 投稿者の特定
![Slide4](https://user-images.githubusercontent.com/62014389/122201094-a0bd0f00-ced6-11eb-916c-6d42668e9860.jpg)
投稿にもブロックにもユーザIDは記述されていません。  
新しいブロックを取得するたびにそのブロックに含まれる電子署名を照合できる鍵の持ち主を投稿者としてブロックに紐づけ、その投稿者が次に使うPublic Keyを更新することで投稿者を特定し続けます。

## プログラムの構成　
### 登録
### register(username,password)
登録する
#### RegisterMetaData registerMetaData = createRegisterMetaData(username, password)
登録データを作成する
#### Blockchain responseRegister = requestRegister(registerMetaData)
サーバに登録データを送信し、返し値としてブロックチェーンを取得する
#### saveBlockchain(responseRegister)
ブロックチェーンを保存する
#### checkRegistered(registerMetaData, responseRegister, password)
返されたブロックチェーンの電子署名と作成した登録データの電子署名を比較することで、登録されたことを確認する

### 投稿
### post(content)
投稿する
#### PostMetaData postMetaData = createPostMetaData(content)
投稿データを作成する
#### Blockchain responsePost = requestPost(postMetaData)
サーバに投稿データを送信し、返し値としてブロックチェーンを取得する
#### blockchained(responsePost)
返されたブロックチェーンの連続性を確認し保存する
#### checkPosted(postMetaData, responsePost)
返されたブロックチェーンの電子署名と作成した登録データの電子署名を比較することで、投稿されたことを確認する

### 閲覧
### List<PostData> postDataList view()
閲覧するためのデータを返す
#### Blockchain responseBlockchain = requestBlockchain()
ブロックチェーンを更新するためにサーバにブロックチェーンを要求し取得する
#### blockchained(responseBlockchain)
返されたブロックチェーンの連続性を確認し保存する
#### Blockchain unknownRegisterBlockchain = getUnknownRegisterBlockchain()
登録のブロックのうち、登録者がわからないブロックを取得する
#### ResponseView responseView = requestView(unknownRegisterBlockchain)
サーバに指定した登録データと投稿データを要求する
#### verifyRegisterBlockchain(responseView.user, unknownRegisterBlockchain)
ブロックに含まれる電子署名と返された登録データを照合しながら、ユーザ情報を保存する
#### List<PostData> postDataList = associateUserIDWithPostBlockchain(responseView.post)
ブロックに含まれる電子署名と返された投稿データを照合しながら、ある投稿の投稿者が誰であるか特定しブロックに投稿者を登録することで閲覧するためのデータを作成する
　
## 技術
### フレームワーク・ライブラリ
### サーバ(使用言語:Rust)
Actix Web : Webサーバ.  
Diesel    : ORM  
Mariadb  

その他 serde(シリアル化),dotenv(.env),regex(正規表現),chrono(時間),rust-crypto(暗号系)  

### クライアント(使用言語:Dart)
Flutter   : クロスプラットフォームでモバイルアプリを作るためのフレームワーク  
SQLite  

その他 cryptography(暗号系),http(通信),shared_preferences,sqflite,path,uuid(ユーザID)  


## 追加したい機能
- タグによる限定公開(秘匿メッセージ)  
- 確認機能(管理者のみが誰が送ったかがわかり、内容は全体公開)  
- 検索機能  
- サーバの回復機能  
- ユーザ名の更新  
- ユーザ側で保存する自分以外の投稿の制限  
- ブロックチェーンの圧縮機能  
- 並列処理  
- 投稿・閲覧の処理を効率化  