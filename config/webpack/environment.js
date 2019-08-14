const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')

const vue =  require('./loaders/vue')
const vueSvgLoader = require('./loaders/vue-svg-loader')
const pug = require('./loaders/pug')

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.append('vue', vue)
environment.loaders.append('vue-svg-loader', vueSvgLoader)
environment.loaders.append('pug', pug)

module.exports = environment
