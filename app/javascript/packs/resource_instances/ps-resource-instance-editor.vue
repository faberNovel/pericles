<script>
  import Editor, {DefaultEditorOptions} from '../common/ps-editor';
  import './styles.scss';

  export default {
    name: 'ps-resource-instance-editor',
    components: {
      'ps-monaco-editor': Editor,
    },
    props: {
      operation: {
        type: String,
        required: true,
        validator: function(value) {
          return ['create', 'update'].indexOf(value) !== -1;
        },
      },
      name: {
        type: String,
        required: true,
      },
      initialvalue: {
        type: String,
        required: true,
      },
    },
    data: function() {
      return {
        resourceName: this.name,
        value: this.initialvalue,
        uri: undefined,
        editor: undefined,
        monaco: undefined,
        options: DefaultEditorOptions,
      };
    },
    computed: {
      operationMessage: function() {
        if (this.operation === 'create') {
          return 'Create';
        } else if (this.operation === 'update') {
          return 'Update';
        } else {
          return 'Unknown operation';
        }
      },
    },
    watch: {
      editor: function(newEditor, oldEditor) {
        if (oldEditor === undefined && newEditor !== undefined) {
          // Editor just got instanciated. Create model
          this.options.model = this.monaco.editor.createModel(this.value, 'json', this.uri);
          // FYI, there is a weird bug where when model is declared as undefined in COMPONENT.data.options, Vue exceeds it's call stack.
        }
      },
    },
    methods: {
      updateValue(value) {
        this.value = value;
      },
      setMonaco(monaco) {
        if (!this.monaco) {
          this.monaco = monaco;
          this.uri = this.monaco.Uri.parse('file://test.json');
          this.monaco.languages.json.jsonDefaults.setDiagnosticsOptions({
            validate: true,
            schemas: [
              {
                uri: 'http://localhost:3000/test-schema.json',
                fileMatch: this.uri.toString(),
                // schema: Provide schema here
              },
            ],
          });
        }
      },
      setEditor(editor) {
        if (!this.editor) {
          this.editor = editor;
        }
      },
    },
  };
</script>

<template>
    <div class="page">
        <h2 style="margin-top: 0">{{ operationMessage }} Mock</h2>
        <div class="flex-v-end">
            <div class="form-group flex" style="margin-right: 15px">
                <label class="control-label required" for="resource_instance_name">Resource name</label>
                <input class="form-control" type="text" v-model="resourceName"
                       id="resource_instance_name">
            </div>
            <div class="form-group" style="margin-left: auto">
                <button class="btn btn-primary">{{ operationMessage }} resource</button>
            </div>
        </div>
        <div class="editor">
            <ps-monaco-editor language="json" :value="value" :options="options" @change="updateValue"
                              @editorWillMount="setMonaco" @editorDidMount="setEditor"/>
        </div>
    </div>
</template>
