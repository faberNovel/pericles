<script>
  import Editor from "../common/ps-editor"
  import "./styles.scss"

  export default {
    name: 'ps-resource-instance-editor',
    components: {
      'ps-monaco-editor': Editor,
    },

    data: () => ({
      value: `{ "id": "test" }`,
      options: {},
      uri: undefined,
    }),

    watch: {
      value: function(newValue) {
        console.log("value", newValue)
      }
    },

    methods: {
      updateValue(value) {
        this.value = value
      },
      setMonaco(monaco) {
        console.log("monaco")
        this.monaco = monaco
        this.uri = this.monaco.Uri.parse("file://test.json")
        this.monaco.languages.json.jsonDefaults.setDiagnosticsOptions({
          validate: true,
          schemas: [
            {
              uri: "http://localhost:3000/test-schema.json",
              fileMatch: this.uri.toString(),
              schema: {
                type: "object",
                required: ["first_name", "last_name"],
                properties: {
                  first_name: {
                    type: "string"
                  },
                  last_name: {
                    type: "string"
                  }
                }
              }
            }
          ]
        })
      },
      setEditor(editor) {
        console.log("editor")
        this.editor = editor
        this.options = {
          ...this.options,
          model: this.monaco.editor.createModel(this.value, "json", this.uri)
        }
      }
    }
  };
</script>
<template>
    <div class="page">
        <h1 style="margin: 0">Resource</h1>
        <div class="test">
            <ps-monaco-editor language="json" :value="value" :options="options" @change="updateValue" @editorWillMount="setMonaco" @editorDidMount="setEditor" />
        </div>
    </div>
</template>
