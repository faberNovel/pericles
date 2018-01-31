<template lang="pug">
.flexcontainer.flexwrap#table
  .table-row
    .cell Name
    .cell Type
    .cell Nullable
    .cell Representations
    .cell
      .btn(@click='onClickExpandAll') Expand All
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
    }
  },
  components: {'ps-attribute': AttributeComponent}
}
</script>

<style scoped>
</style>
