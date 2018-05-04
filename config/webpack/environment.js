const { environment } = require('@rails/webpacker')
const vue =  require('./loaders/vue')
const vueSvgLoader = require('./loaders/vue-svg-loader')

environment.loaders.get('file').test = /\.(jpg|jpeg|png|gif|tiff|ico|eot|otf|ttf|woff|woff2)$/i
environment.loaders.append('vue', vue)
environment.loaders.append('vue-svg-loader', vueSvgLoader)
module.exports = environment
