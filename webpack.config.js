const path = require("path");
const webpack = require("webpack");

module.exports = {
  mode: "production",
  devtool: "source-map",
  entry: {
    application: "./app/javascript/application.js"
  },
  output: {
    filename: "[name].js",
    sourceMapFilename: "[name].js.map",
    path: path.resolve(__dirname, "app/assets/builds")
  },
  module: {
    rules: [
      {
        test: /\.(j|t)sx?$/,
        // Targeting problematic package, https://stackoverflow.com/a/60395448
        include: [
          path.resolve(__dirname, "app/javascript"),
          path.resolve(__dirname, "node_modules/axios-retry")
        ],
        exclude: /node_modules\/(?!(axios-retry)\/).*/,
        use: {
          loader: "babel-loader",
          options: {
            presets: [
              [
                "@babel/preset-env",
                {
                  useBuiltIns: "entry",
                  corejs: "3.20"
                }
              ]
            ]
          }
        }
      }
    ]
  },
  plugins: [
    new webpack.optimize.LimitChunkCountPlugin({
      maxChunks: 1
    })
  ]
};
