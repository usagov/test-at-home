module.exports = {
  syntax: "postcss-scss",
  plugins: [
    require("@csstools/postcss-sass"),
    require("postcss-import"),
    require("autoprefixer")
  ]
};
