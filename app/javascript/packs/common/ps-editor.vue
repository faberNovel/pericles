<script>

  import * as monaco from 'monaco-editor';
  import MonacoEditor from 'vue-monaco';
  import './ps-editor.scss';

  self.MonacoEnvironment = {
    getWorkerUrl: function(moduleId, label) {
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
    },
  };

  export default {
    name: 'ps-monaco-editor',
    components: {
      'monaco-editor': MonacoEditor,
    },

    props: {
      originalValue: String,
      value: {
        type: String,
        required: true,
      },
      theme: {
        type: String,
        default: 'vs',
      },
      language: String,
      options: {
        type: Object,
        default: () => ({}),
      },
      diffEditor: {
        type: Boolean,
        default: false,
      },
    },

    computed: {
      editorOptions: function() {
        return {
          automaticLayout: true,
          fontSize: 14,
          minimap: {enabled: false},
          scrollBeyondLastLine: false,
          ...this.options,
        };
      },
    },

    methods: {
      handleChange(value, event) {
        this.$emit("change", value, event)
      },
      handleWillMount(monaco) {
        this.$emit("editorWillMount", monaco)
      },
      handleDidMount(editor) {
        this.$emit("editorDidMount", editor)
      }
    }
  };
</script>

<template>
    <monaco-editor
            id="monaco-editor"
            :value="value"
            :original="originalValue"
            :language="language"
            :theme="theme"
            :options="editorOptions"
            :diff-editor="diffEditor"
            @change="handleChange"
            @editorWillMount="handleWillMount"
            @editorDidMount="handleDidMount"
    />
</template>