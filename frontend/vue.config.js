const { defineConfig } = require('@vue/cli-service')
const path = require('path');


module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: "",

  pluginOptions: {
    cordovaPath: "src-cordova",
  },

  outputDir: path.resolve(__dirname, "./MobileApp/www"), // Chemin vers le dossier www de Cordova
  chainWebpack: (config) => {
    config.output
      .filename("assets/[name].js")
      .chunkFilename("assets/[name].js");

    config.plugin("copy").tap((args) => {
      return args;
    });
  },
});
