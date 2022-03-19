import Vue from 'vue';
import Router from 'vue-router'; // urlごとに異なるページを表示する公式プラグイン
import HomePage from './pages/HomePage.vue';

Vue.use(Router) // vue-routerプラグインを使用する宣言

export default new Router({
  mode: 'history',
  // ここでurlとページを対応させる
  routes: [
    {path: '/', component: HomePage}
  ]
});