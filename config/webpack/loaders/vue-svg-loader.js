module.exports = {
  test: /\.svg$/,
  loader: 'vue-svg-loader', // `vue-svg` for webpack 1.x
  options: {
    // optional [svgo](https://github.com/svg/svgo) options
    svgo: {
      plugins: [
        {removeDoctype: true},
        {removeComments: true}
      ]
    }
  }
}
