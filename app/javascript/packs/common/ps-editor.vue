<script>

  import * as monaco from 'monaco-editor';
  import "./ps-editor.scss"

  self.MonacoEnvironment = {
    getWorkerUrl: function (moduleId, label) {
      if (label === 'json') {
        return '/packs/json.worker.chunk.js';
      }
      if (label === 'css') {
        return '/packs/css.worker.chunk.js';
      }
      if (label === 'html') {
        return '/packs/html.worker.chunk.js';
      }
      if (label === 'typescript' || label === 'javascript') {
        return '/packs/ts.worker.chunk.js';
      }
      return '/packs/editor.worker.chunk.js';
    }
  }

  export default {
    name: 'Monaco-Editor',

    props: {
      value: {
        type: String,
        required: true
      },
      theme: {
        type: String,
        default: 'vs'
      },
      language: String,
      options: {
        type: Object,
        default: () => ({})
      },
    },

    model: {
      event: 'change'
    },

    mounted() {
      this.initEditor();
    },

    watch: {
      options: {
        deep: true,
        handler(options) {
          if (this.editor) {
            this.editor.updateOptions(options)
          }
        }
      },

      value(val) {
        if (this.editor) {
          if (val !== this.editor.getValue()) {
            this.editor.setValue(val)
          }
        }
      },

      language(lang) {
        if (this.editor) {
          this.editor.setModelLanguage(this.editor.getModel(), lang)
        }
      },

      theme(theme) {
        if (this.editor) {
          this.editor.setTheme(theme)
        }
      },
    },

    methods: {
      initEditor() {
        const options = {
          language: this.language,
          theme: this.theme,
          automaticLayout: true,
          fontSize: 14,
          minimap: { enabled: false },
          scrollBeyondLastLine: false,

          ...this.options,
          value: this.value,
        }

        this.editor = monaco.editor.create(this.$el, options)

        this.editor.onDidChangeModelContent(event => {
          const value = this.editor.getValue()
          if (this.value !== value) {
            this.$emit('change', value, event)
          }
        })

        this.$emit('editorDidMount', this.editor)
      },
    },
  };
</script>

<template>
<div id="monaco-editor"></div>
</template>