<template lang="pug">
div(style='margin-top: -1px;')
  a(
    class='list-group-item'
    :href='resourcePath'
  )
    .flexcontainer-space-between
      .name {{displayedResourceName}}
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
  )
</template>

<script>
import Store from './store.js';

export default {
  props: ['resource', 'treeMode', 'depth'],
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
      return '      '.repeat(this.depth) + ((this.depth == 0) ? '' : '↳ ') + this.resource.name
    },
  },
  name: 'ps-resource'
}
</script>

<style scoped>
</style>
