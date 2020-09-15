<script>
  import MonacoEditorComponent from 'vue-monaco';

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

  export const DefaultEditorOptions = {
    fontSize: 14,
    minimap: {enabled: false},
    scrollBeyondLastLine: false,
    automaticLayout: true,
  };

  export default {
    name: 'ps-monaco-editor',
    extends: MonacoEditorComponent,
    props: {
      options: {
        type: Object,
        default: function() {
          return DefaultEditorOptions;
        },
      },
    },
  };
</script>