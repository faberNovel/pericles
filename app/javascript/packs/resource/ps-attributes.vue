<template lang="pug">
.flexcontainer.flexwrap#table
  .table-row
    .cell Name
    .cell Type
    .cell Nullable
    .cell Representations
    .cell
      .btn(v-if='shouldShowExpandAll'
        @click='onClickExpandAll'
    ) Expand All
      .btn(v-else
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
