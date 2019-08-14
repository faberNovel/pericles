<template lang="pug">
div(style='margin-top: -1px;')
  a(
    class='list-group-item'
    :href='resourcePath'
  )
    .flexcontainer-space-between
      .name(v-html='displayedResourceName')
      vue-markdown(class='markdown short-description', style='flex: 1; margin-left: 20px', :source='displayedResourceDescription')
      .error(style='flex-basis: 50px', v-if='resource.hasInvalidMocks')
        .tool-tip(
          data-toggle="tooltip"
          data-placement="top"
          title="Invalid mocks !"
        ) /!\

  ps-resource(
    v-if='shouldDisplayChildren'
    v-for='r in displayedChildren'
    :resource='r',
    :tree-mode='treeMode',
    :depth='depth + 1'
    :query='query'
    :visited-resources='visitedAndUsedResources'
  )
</template>

<script>
import VueMarkdown from 'vue-markdown'
import Store from './store.js';

export default {
  props: ['resource', 'treeMode', 'depth', 'query', 'visitedResources'],
  methods: {
  },
  computed: {
    resourcePath: function() {
      return document.location.pathname + '/' + this.resource.id;
    },
    usedResources: function() {
      return Store.findResourcesByIds(this.resource.usedResources.map((r) => r.id))
    },
    shouldFilterChildren: function() {
      return !this.treeMode && !(this.query == null || this.query.length === 0);
    },
    filteredResources: function () {
      return this.usedResources.filter((r) => {
        let resourceMatchingQuery = Store.isResourceMatchingQuery(r, this.query);
        let hasNestedChildrenMatchingQuery = Store.hasNestedChildrenMatchingQuery(r, this.query);
        return resourceMatchingQuery || hasNestedChildrenMatchingQuery;
      });
    },
    visitedAndUsedResources: function() {
      return [...this.visitedResources, ...this.usedResources];
    },
    displayedChildren: function() {
      let children = this.shouldFilterChildren ? this.filteredResources : this.usedResources;

      if (this.visitedResources) {
        const visitedResourceIds = this.visitedResources.map((r) => r.id);
        children = children.filter((r) => !visitedResourceIds.includes(r.id));
      }
      return children;
    },
    displayedResourceName: function() {
      let indentation = '      '.repeat(this.depth) + ((this.depth == 0) ? '' : '↳ ');

      return indentation + this.highlightedName;
    },
    displayedResourceDescription: function() {
      return this.resource.description;
    },
    shouldDisplayChildren: function() {
      if (this.treeMode) {
        return this.depth < 10
      }

      return this.depth < 10 && Store.hasNestedChildrenMatchingQuery(this.resource, this.query);
    },
    highlightedName: function() {
      let name = this.resource.name;

      if (!this.query || this.query.length === 0) {
        return name;
      }

      let permissiveQuery = Store.permissiveQuery(this.query);
      let reg = new RegExp(permissiveQuery, 'gi');
      let result = reg.exec(this.resource.name);

      if (!result) {
        return name;
      }

      let newName = '';
      let foundIndice = 1;
      name.split('').forEach((char) => {
        if (foundIndice < result.length && result[foundIndice] == char) {
          foundIndice += 1;
          newName += '<b>'+ char + '</b>';
        } else {
          newName += char
        }
      });

      return newName;
    }
  },
  name: 'ps-resource',
  components: {'vue-markdown': VueMarkdown}
}
</script>

<style scoped>
</style>
