<script>
  import Editor, {DefaultEditorOptions} from '../common/ps-editor';
  import './styles.scss';

  function camelize(str) {
    return str.replace(/(?:^\w|[A-Z]|\b\w)/g, function(word, index) {
      return index == 0 ? word.toLowerCase() : word.toUpperCase();
    }).replace(/\s+/g, '');
  }

  const testSchema = (name, uri) => ({
    uri: `http://localhost:3000/${name}-schema.json`,
    fileMatch: [uri.toString()],
    // schema: Provide schema here
    schema: {
      type: 'object',
      required: [
        'first_name',
        'last_name',
      ],
      properties: {
        first_name: {
          type: 'string',
        },
        last_name: {
          type: 'string',
        },
        age: {
          type: 'integer',
        },
        division: {
          type: 'string',
          enum: [
            'technologies',
            'customer',
            'transformation',
          ],
        },
      },
    },
  });
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
      const normalizedName = camelize(this.name);
      return {
        normalizedName,
        resourceName: this.name,
        value: this.initialvalue,
        uri: undefined,
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
    methods: {
      updateValue(value) {
        this.value = value;
      },
      setMonaco(monaco) {
        if (!this.monaco) {
          this.monaco = monaco;
          const uri = monaco.Uri.parse(`a://test.json`);
          this.uri = uri;
          this.options.model = monaco.editor.createModel(this.value, 'json', uri);
          monaco.languages.json.jsonDefaults.setDiagnosticsOptions({
            validate: true,
            schemas: [
              {
                uri: 'http://localhost:3000/test-schema.json',
                fileMatch: [uri.toString()],
                schema: {
                  type: 'object',
                  required: [
                    'first_name',
                    'last_name',
                  ],
                  additionalProperties: false,
                  properties: {
                    first_name: {
                      type: 'string',
                    },
                    last_name: {
                      type: 'string',
                    },
                    age: {
                      type: 'integer',
                    },
                    division: {
                      type: 'string',
                      enum: [
                        'technologies',
                        'customer',
                        'transformation',
                      ],
                    },
                  },
                },
              },
            ],
          });
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
                              @editorWillMount="setMonaco"/>
        </div>
    </div>
</template>
