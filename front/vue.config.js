const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  pages: {
    index: {
      entry: "src/main.js",
      title: "玉兎の札-封印されし力-"
    }
  },
  transpileDependencies: [
    'vuetify'
  ]
})