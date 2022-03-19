<template>
  <span class="body">
    <header class="header-area">
      <h1>玉兎の札-封印されし力-</h1>
    </header>
    <div class="body-area">
    <div v-if="loading===true" class='loading'></div>
      <!-- 設定エリア ---------------------------------------------------->
      <div class="setting-area">
        <div class="setting-block">
          <!-- カテゴリ選択 -->
          <div class="body__setting-category">
            <div class="setting-category-title">言語</div>
            <select v-model="selectedCategory" class="setting-category-select">
              <option value="html">HTML</option>
              <option value="css">CSS</option>
              <option value="ruby">Ruby</option>
              <option value="java">Java</option>
              <option value="linux">Linux</option>
              <option value="javascript">JavaScript</option>
            </select>
          </div>
          <!-- START -->
          <!-- body__setting--start -->
          <v-btn x-large v-on:click="gameStart()">
            {{buttonText}}
          </v-btn>
        </div>
      </div>

      <!-- タイマーエリア ------------------------------------------------->
      <div class="timer-area">
        <div :class="{'moving-area': startRabbit}">
          <img src="@/assets/usagi.png" alt="rabbit-image" class="moving-rabbit">
        </div>
        <div class="time-bar"></div>
      </div>
      <!-- カードエリア --------------------------------------------------->
      <div class="card-area">
        <v-row
          v-for="rowNumber in 3"
          :key="rowNumber">
          <v-col
            v-for="colNumber in 6"
            :key="colNumber"
            class="card-col">
            <button
              class="card-button"
              v-on:click="clicked(rowNumber,colNumber)">
              <div class="card-space">
                <!-- カードの表 -->
                <template v-if="checkCleared(rowNumber,colNumber) === false">
                  <v-img
                    src='~/../assets/card_front.png'
                    max-width="100">
                  </v-img>
                  <span class='card-text'>{{ cardWord(rowNumber,colNumber) }}</span>
                </template>
                <!-- カードの裏 -->
                <template v-if="checkOpened(rowNumber,colNumber) === false">
                  <div class=card-back>
                    <v-img
                      src='~/../assets/card_back_red.png'
                      max-width="100">
                    </v-img>
                  </div>
                </template>
              </div>
            </button>
          </v-col>
        </v-row>
      </div>

      <!-- 情報表示エリア ------------------------------------------------->
      <div class="information-area">
        <div class="information-block">
          <h3>{{informationComment}}</h3>
          <div>{{cardExplain}}</div>
        </div>
      </div>
    </div>
    <footer>
      <!-- 効果音提供 オトロジック(https://otologic.jp) -->
    </footer>
  </span>
</template>
<script>
import axios from 'axios';
export default {
  data () {
    return {
      cardStatus: [
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false},
        { word: "", explain: "", opened: false, cleared: false}
      ],
      selectedCategory: 'javascript',
      clickedIndex: null,
      previousClickedIndex: null,
      openedCardNum: 0,
      informationComment: null,
      cardExplain: null,
      startRabbit: false,
      gameState: 'waiting', // 'waiting' or 'playing' or 'gameOver'
      buttonText: 'START',
      gameOverFlag: false,
      gameOverTimer: undefined,
      loading: false,
      remainingPairs: 9
    }
  },
  watch: {
    // ゲームオーバーになっていないか監視している
    gameOverFlag: function(newVal) {
      if(newVal) {
        // --- ゲームオーバーになった場合の処理 ---
        // 裏のカードを全て表にする
        for (const card of this.cardStatus) {
            card['opened'] = true;
        }
        // メッセージを表示
        this.informationComment = "時間切れ。また挑戦してね！"
        // カード説明をリセット
        this.cardExplain = null;
        // ゲームオーバーフラグをリセット
        this.gameOverFlag = false;
      }
    },
    remainingPairs: function(newVal) {
      if(newVal === 0) {
        // メッセージを表示
        this.informationComment = "ゲームクリア！おめでとう！"
        // カード説明をリセット
        this.cardExplain = null;
        // タイマー停止（削除）
        clearTimeout(this.gameOverTimer);
        // うさぎ停止
        this.startRabbit = false;
        // その他設定をスタート前に戻す
        this.gameState = 'waiting'
        this.buttonText = 'START'
      }
    }
  },
  methods: {
    // 汎用メソッド ---------------------------------------------
    // カード開示状況の初期化
    refleshCardOpenStatus() {
      this.openedCardNum = 0;
      this.clickedIndex = null;
      this.previousClickedIndex = null;
    },
    // 設定エリア -----------------------------------------------
    // STARTボタンクリック時の処理
    async gameStart() {
      this.controllGameState(); // ゲームの状態を管理
      if(this.gameState === 'playing') this.loading = true // ゲームスタートで読み込み画面表示
      this.reverseAllCard();  // カードを全て裏にする
      this.refleshCardOpenStatus(); // カード開示状況の初期化
      if(this.gameState === 'playing') await this.getQuestions();  // カードをセット
      this.operateRabbit();  // うさぎを操作する
      this.startTimer(); // タイマーを開始する
      this.remainingPairs = 9;
      this.informationComment = null;
      this.loading = false
    },
    // タイマーを開始する
    startTimer() {
      clearTimeout(this.gameOverTimer);
      if(this.gameState === 'playing' || this.gameState === 'gameOver') {
        this.gameOverTimer = setTimeout(() => {
          this.gameOverFlag = true}
          ,60100
        )
      }
    },
    // ゲームの状態を管理
    controllGameState() {
      if (this.gameState === 'playing' || this.gameState === 'gameOver') {
        this.gameState = 'waiting'
        this.buttonText = 'START'
      } else {
        this.gameState = 'playing'
        this.buttonText = 'GIVE UP'
      }
    },
    // 全てのカードを裏にする
    reverseAllCard() {
      for (const card of this.cardStatus) {{
        card['opened'] = false;
        card['cleared'] = false;
      }}
    },
    // バックエンドからカード情報を取得する
    async getQuestions() {
      await axios.get(`http://localhost:3000/api/v1/questions/${this.selectedCategory}`).then(res => {
        const questions = res.data['questions']
        const length = this.cardStatus.length
        for(let index = 0; index < length ; index++) {
          this.cardStatus[index]['word'] = questions[index]['word']
          this.cardStatus[index]['explain'] = questions[index]['explain']
        }
      })
    },
    // タイマーエリア --------------------------------------------
    // うさぎを操作する
    operateRabbit() {
      if (this.startRabbit) {
        this.startRabbit = false;
      } else {
        this.startRabbit = true;
      }
    },
    // カードエリア ----------------------------------------------
    // 行と列からカードの配列番号を調べる
    cardIndex(rowNumber, colNumber) {
      return (rowNumber-1)*6 + colNumber-1;
    },
    // 行と列からカードの絵柄を調べる
    cardWord(rowNumber,colNumber) {
      const index = this.cardIndex(rowNumber, colNumber);
      return this.cardStatus[index]['word']
    },
    // 行と列からカードが正解済みか調べる
    checkCleared(rowNumber,colNumber) {
      const index = this.cardIndex(rowNumber, colNumber);
      return this.cardStatus[index]['cleared']
    },
    // 行と列からカードが開かれているか調べる
    checkOpened(rowNumber,colNumber) {
      const index = this.cardIndex(rowNumber, colNumber);
      return this.cardStatus[index]['opened']
    },
    // カードがクリックされたときの処理
    clicked(rowNumber,colNumber) {
      const clickedIndex = this.cardIndex(rowNumber, colNumber);
      const clickedCardStatus = this.cardStatus[clickedIndex];
      const clickedCardWord = this.cardWord(rowNumber,colNumber);
      if (this.openedCardNum < 2 &&                 // 表になっているカードが０枚か１枚
          clickedCardStatus['opened'] === false &&  // 選択されたカードがまだ表になっていない
          clickedCardStatus['cleared'] === false && // 選択されたカードが正解済みでない
          this.gameState === 'playing') {           // スタートボタンが押されている
        // 選択中カード（今回・前回）を更新
        this.previousClickedIndex = this.clickedIndex;
        this.previousClickedCardWord = this.clickedCardWord // 1つ前の選択肢したカード
        this.clickedIndex = clickedIndex;
        this.clickedCardWord = clickedCardWord; // 選択したカード
        // 今回選択されたカードを開く
        this.cardStatus[this.clickedIndex]['opened'] = true;
        this.openedCardNum++;
        this.informationComment = null;
        this.cardExplain = null;
        // カードが2枚目開かれたとき、絵柄が同じが調べる
        if (this.openedCardNum === 2) {
          // 開いたカードの絵柄を確認できるディレイタイムを設けている
          setTimeout(this.cardPairCheck, 700);
        }
      }
    },
    // カードが2枚開かれたときの処理
    cardPairCheck() {
      const clickedCardWord = this.cardStatus[this.clickedIndex]['word'];
      const previousClickedCardWord = this.cardStatus[this.previousClickedIndex]['word'];
      const cardExplain = this.cardStatus[this.previousClickedIndex]['explain'];

      if (clickedCardWord === previousClickedCardWord) {
        // 同じ絵柄だった時 => カードを盤面から取り除く
        this.cardStatus[this.clickedIndex]['cleared'] = true;
        this.cardStatus[this.previousClickedIndex]['cleared'] = true;
        this.informationComment = "当たり！"
        this.cardExplain = cardExplain;
        this.remainingPairs = this.remainingPairs - 1;
      } else {
        // 違う絵柄だった時 => カードを裏にする
        this.cardStatus[this.clickedIndex]['opened'] = false;
        this.cardStatus[this.previousClickedIndex]['opened'] = false;
        this.informationComment = "ざんねん！"
      }
      // カード開示状況の初期化
      this.refleshCardOpenStatus();
    },
  }
}
</script>
<style scoped lang="scss">
.header-area {
  height: 60px;
  background-color: rgb(0, 0, 0);
  color:#e6e6e6;
  padding-top: 6px;
  padding-left: 12px;
}
.body-area {
  border-top: solid 1px gray;
  background-color: rgb(68, 68, 68);
  height: 100%;
}
.loading {
	position: fixed; /* ブラウザの定位置に固定 */
	background: rgba(0, 0, 0, .5); /* 背景色を半透明の黒色に */
	width: 100%; /* 要素の横幅を画面全体に */
	height: 100%; /* 要素の高さを画面全体に */
	top: 0; /* 要素の固定位置をブラウザ最上部に合わせる */
	left: 0; /* 要素の固定位置をブラウザ左側に合わせる */
	z-index: 1000; /* 要素をコンテンツより前面に（要調整） */
}
.body {
  position: fixed; /* ブラウザの定位置に固定 */
	background: rgb(122, 122, 122); /* 背景色を半透明の黒色に */
	width: 100%; /* 要素の横幅を画面全体に */
	height: 100%; /* 要素の高さを画面全体に */
	top: 0; /* 要素の固定位置をブラウザ最上部に合わせる */
	left: 0; /* 要素の固定位置をブラウザ左側に合わせる */
	z-index: 0; /* 要素をコンテンツより前面に（要調整） */
}

// 設定エリア ----------------------------------------------------
.setting-area {
  position: relative;
  height: 60px;
  margin: 20px 0 20px 0;
}
.setting-block {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  display: flex;
}
.body__setting-category {
  display: flex;
}
.setting-category-select {
  width: 100px;
  text-align: center;
  margin-right: 30px;
  display: block;
  background-color: whitesmoke;
  border-radius: 6%;
  height: 50px;
  box-shadow: 1px 1px 4px grey;
}
.setting-category-title {
  text-align: center;
  padding: 14px 0;
  margin-right: 10px;
  color: #e6e6e6;
  font-weight: bold;
}
// タイマーエリア -------------------------------------------------
.timer-area {
  width: 80%;
  height: 90px;
  margin: 60px auto;
  margin-top: 20px;
}
.moving-area {
  animation-name: rabbit-image;
  animation-duration: 60s; // アニメーションの時間
  animation-timing-function: linear; // 一定の速さで再生
  animation-direction: normal; // 左から右に再生
  animation-fill-mode:forwards; // 最後の状態で停止
}
.moving-rabbit {
  width: 7%;
  height: auto;
  position: relative;
  left: 10%;
  bottom: 10%;
}
@keyframes rabbit-image {
  from {
    transform: translateX(0%);
  }
  to {
    transform: translateX(75%);
  }
}
.time-bar {
  width: 80%;
  margin: 0 auto;
  border: 8px solid green;
  border-radius: 20px;
}
// カードエリア --------------------------------------------------
.card-area {
  width:594px;
  height: 456px;
  margin: 0 auto;
  padding-top: 12px;
}
.card-col {
  display: flex;
  padding: 1px;
  background-color: #CD853F;
}
.card-button {
  height: 150px;
}
.card-space {
  position: relative;
}
.card-text {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  font-weight: bold;
}
.card-back {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}
// 情報表示エリア -------------------------------------------------
.information-area {
  position: relative;
}
.information-block {
  margin-top: 20px;
  background-color: #C0C0C0;
  border: 2px solid #0000006e;
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, 0%);
  height: 120px;
  width: 620px;
}
</style>