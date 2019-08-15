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
    }),

    watch: {
      value: function(newValue) {
        console.log("value", newValue)
      }
    },

    methods: {
      updateValue(value) {
        this.value = value
      }
    }
  };
</script>
<template>
    <div class="page">
        <h1 style="margin: 0">Resource</h1>
        <ps-monaco-editor language="json" :value="value" @change="updateValue" />
    </div>
</template>
