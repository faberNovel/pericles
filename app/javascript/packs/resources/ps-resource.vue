<template lang="pug">
div(style='margin-top: -1px;')
  a(
    class='list-group-item'
    :href='resourcePath'
  )
    .flexcontainer-space-between
      .name(v-html='displayedResourceName')
      .error(v-if='resource.hasInvalidMocks')
        .tool-tip(
          data-toggle="tooltip"
          data-placement="top"
          title="Invalid mocks !"
        ) /!\

  ps-resource(
    v-if='treeMode && depth < 10'
    v-for='r in usedResources'
    :resource='r',
    :tree-mode='treeMode',
    :depth='depth + 1'
    :query='query'
  )
</template>

<script>
import Store from './store.js';

export default {
  props: ['resource', 'treeMode', 'depth', 'query'],
  methods: {
  },
  computed: {
    resourcePath: function() {
      return document.location.pathname + '/' + this.resource.id;
    },
    usedResources: function() {
      return Store.findResourcesByIds(this.resource.usedResources.map((r) => r.id))
    },
    displayedResourceName: function() {
      let indentation = '      '.repeat(this.depth) + ((this.depth == 0) ? '' : '↳ ');

      return indentation + this.highlightedName;
    },
    highlightedName: function() {
      let name = this.resource.name;
      if (this.query && this.query.length > 0) {
        let reg = new RegExp('(' + this.query + ')', 'gi');
        name = this.resource.name.replace(reg, '<b>$1</b>');
      }
      return name;
    }
  },
  name: 'ps-resource'
}
</script>

<style scoped>
</style>
