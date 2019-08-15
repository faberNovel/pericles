<template>
<div class="page">
    <h1 style="margin: 0">Resource</h1>
    <div class="editor-wrapper">
        <ps-editor language="json" :value="value" />
    </div>
</div>
</template>

<script>
  import Editor from "../common/ps-editor"
  import "./styles.scss"

  export default {
    name: 'ps-resource-instance-editor',
    components: {
      'ps-editor': Editor
    },
    data: () => ({
      value: `{ "id": "test" }`,
    }),

    watch: {
      value: function(newValue) {
        console.log("value", newValue)
      }
    }
  };
</script>