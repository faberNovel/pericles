<template lang="pug">
.host

  .flexspace-and-center
    input.form-control(
      @input="updateSearchQuery"
      placeholder='Search'
      style='width: auto;'
    )
    div
      button.btn(@click='onTreeClick', :class='{grayscaled: !treeMode}') 🌳
      //- TODO Clément Villain 19/02/18
      //- - if user.can_create? Resource, project: project
      a(
        class="btn btn-primary btn-lg"
        :href="newResourcePath"
      ) New Resource

  .list.margin-top-element
    ps-resource(
      v-for='resource in resources'
      :resource='resource'
      :tree-mode='treeMode'
      :depth='0'
      :query='query'
    )
</template>

<script>
import ResourceComponent from './ps-resource.vue';
import Store from './store.js';

export default {
  props: ['resources', 'treeMode', 'query'],
  methods: {
    onTreeClick: function() {
      Store.toggleTreeMode();
    },
    updateSearchQuery: function(event) {
      let value = event.target.value;
      Store.setQuery(value);
    }
  },
  computed: {
    newResourcePath: function() {
      return document.location.pathname + '/new';
    }
  },
  components: {'ps-resource': ResourceComponent}
}
</script>

<style scoped>
</style>
