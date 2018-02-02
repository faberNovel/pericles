<template lang="pug">
.flexcontainer.flexwrap#table
  .table-row
    .cell Name
      a(
        href='#'
        @click='onSortClick'
      )
        img#sort-icon.pull-right(:src='sortIcon')
    .cell Type
    .cell Nullable
    .cell Representations
    .cell
      .btn(
        v-if='shouldShowExpandAll'
        @click='onClickExpandAll'
      ) Expand All
      .btn(
        v-else
        @click='onClickHideAll'
      ) Hide All
  ps-attribute(
    v-for='a in attributes'
    :attribute='a'
    :manage-mode='manageMode'
    :active-representation='activeRepresentation'
  )
</template>

<script>
import sortIcon from 'images/sort-alphabetical.svg';
import Store from './store.js';
import AttributeComponent from './ps-attribute.vue';

export default {
  props: ['attributes', 'manageMode', 'activeRepresentation'],
  methods: {
    onClickExpandAll: function() {
      $('.contraints-row').collapse('show');
      this.shouldShowExpandAll = false;
    },
    onClickHideAll: function() {
      $('.contraints-row').collapse('hide');
      this.shouldShowExpandAll = true;
    },
    onSortClick: function() {
      Store.toggleSort();
    },
  },
  data: function() {
    return {
        shouldShowExpandAll: true
    }
  },
  computed: {
    sortIcon: function() {
      return sortIcon;
    }
  },
  components: {'ps-attribute': AttributeComponent}
}
</script>

<style scoped>
</style>
