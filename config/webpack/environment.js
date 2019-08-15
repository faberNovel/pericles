const { environment } = require('@rails/webpacker')
const VueLoaderPlugin = require('vue-loader/lib/plugin')

const vue =  require('./loaders/vue')
const vueSvgLoader = require('./loaders/vue-svg-loader')
const pug = require('./loaders/pug')

environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

environment.loaders.append('vue', vue)
environment.loaders.append('vue-svg-loader', vueSvgLoader)
environment.loaders.append('pug', pug)

environment.entry.merge({
  "editor.worker": 'monaco-editor/esm/vs/editor/editor.worker.js',
  "json.worker": 'monaco-editor/esm/vs/language/json/json.worker',
  "css.worker": 'monaco-editor/esm/vs/language/css/css.worker',
  "html.worker": 'monaco-editor/esm/vs/language/html/html.worker',
  "ts.worker": 'monaco-editor/esm/vs/language/typescript/ts.worker',
})

environment.config.merge({
  output: {
    globalObject: 'self',
    filename: (chunkData) => {
      if (chunkData.chunk.name.endsWith('.worker')) {
        return '[name].chunk.js'
      } else {
        return '[name]-[contenthash].chunk.js'
      }
    },
  }
})

module.exports = environment
