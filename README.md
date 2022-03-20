# 玉兎の札 -封印されし力-
![アプリ画面](https://user-images.githubusercontent.com/49280097/159147143-7d211721-9955-4113-89ee-eff005992ade.png)

**プログラミング学習を楽しくするWEBアプリケーション For WEBCAMP ENGINEER COMMUNITY HACKATHON**<br>
<br>
## URL
http://35.77.173.219/

## 概要
このアプリは遊びながら楽しくプログラミング学習ができる神経衰弱ゲームです。<br>
ジャンルを選択してスタートボタンを押すとゲームがスタートし、うさぎさんが走り出します。<br>
制限時間は60秒。うさぎさんが走り抜けてしまう前に全てのペアを揃えて神経衰弱をクリアしていきます。<br>
カードの札はプログラミングに関する単語で構成されているので、遊びながら用語を覚えることができます。<br>
<br>
## 遊び方
ジャンルを選択し、スタートボタンを押します。<br>
うさぎさんが走り抜ける前に全てのペアを揃えましょう。<br>
1枚目と2枚めの比較結果をページ下部のエリアに表示します。<br>
同じカードだった場合は、めくった単語の説明が表示されます。<br>
すべてめくり終えるとゲームクリアとなります。<br>
ゲームクリアする前に時間切れになってしまうと、フィールドに残されている全てのカードが裏返され、答え合わせができる仕組みになっています。<br>
<br>
## 使用技術
フロントエンド：Html, CSS, JavaScript, Vue.js, Vuetify<br>
バックエンド：Ruby, Ruby on Rails<br>
データベース：PostgleSQL<br>
インフラ：AWS（VPC, Subnet, EC2, Internet Gateway）<br>
その他：Docker, docker-compose, git, Github<br>

## インフラ構成図
![玉兎の札-インフラ構成図](https://user-images.githubusercontent.com/49280097/159147259-ca22be6d-e7da-4540-80f1-1a18028cb04a.png)

## ER図
![玉兎の札-ER図](https://user-images.githubusercontent.com/49280097/159147256-fae43e9f-8a91-4a16-bf42-91780797bb39.png)
