<template lang="pug">
.flexcontainer.flexwrap#table
  .table-row
    .cell Name
      a(href='#' @click='onAlphabeticalSortClick')
        img#sort-icon.pull-right(:src='sortIcon("alphabetical")')
    .cell Type
      a(href='#' @click='onTypeSortClick')
        img#sort-icon.pull-right(:src='sortIcon("type")')
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
import DefaultSortIcon from 'images/sort.svg';
import SelectedSortIcon from 'images/selected_sort.svg';
import Store from './store.js';
import AttributeComponent from './ps-attribute.vue';

export default {
  props: ['attributes', 'manageMode', 'activeRepresentation', 'sortMode'],
  methods: {
    onClickExpandAll: function() {
      $('.contraints-row').collapse('show');
      this.shouldShowExpandAll = false;
    },
    onClickHideAll: function() {
      $('.contraints-row').collapse('hide');
      this.shouldShowExpandAll = true;
    },
    onAlphabeticalSortClick: function() {
      Store.alphabeticalSort();
    },
    onTypeSortClick: function() {
      Store.typeSort();
    },
    sortIcon: function(sortType) {
      if (sortType === this.sortMode) {
        return SelectedSortIcon;
      } else {
        return DefaultSortIcon;
      }
    }
  },
  data: function() {
    return {
        shouldShowExpandAll: true
    }
  },
  components: {'ps-attribute': AttributeComponent}
}
</script>

<style scoped>
</style>
