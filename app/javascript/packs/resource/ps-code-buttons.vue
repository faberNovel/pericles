<template lang="pug">
.flexcontainer.flexwrap.btn-group(role="group" style='margin-right: 16px;')
  a(:class='classes', :href='computeUrl("json_schema")') JSON schema
  a(:class='classes', :href='computeUrl("swift")') Swift
  a(:class='classes', :href='computeUrl("kotlin")') Kotlin
  a(:class='classes', :href='computeUrl("ruby")') Ruby
  a(:class='classes', :href='computeUrl("graphql")') GraphQL
  a(:class='classes', :href='computeUrl("typescript")') TypeScript
</template>

<script>
export default {
  props: ['resource', 'activeRepresentation'],
  methods: {
    computeUrl: function(language) {
      let path = '';
      if (this.activeRepresentation) {
        path = '/resources/' + this.resource.id + '/resource_representations/' + this.activeRepresentation.id;
      } else {
        path = document.location.pathname;
      }
      return path + '.' + language
    }
  },
  computed: {
    classes: function() {
      if (this.activeRepresentation) {
        return "code btn btn-primary " + this.activeRepresentation.colorClass
      } else {
        return "code btn btn-primary"
      }
    }
  }
}
</script>

<style scoped>
</style>
