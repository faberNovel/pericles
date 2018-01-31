<template lang="pug">
.filter#ps-filter-attributes
  .flexspace-and-center
    div(v-if='!manageMode') Filter by representation :
    div(v-if='manageMode') Manage representations
    transition(name="fade")
      .btn.btn-link(@click='onManageClick'
        v-show='!manageMode'
      ) Manage
  .flexwrap
    transition(name="w-slide-fade")
      .btn.representation-btn#all(
        @click='onAllClick'
        v-show="!manageMode"
      ) All
    .btn.representation-btn(
        v-for='r in representations'
        :id='r.id'
        :class="[{selected: r.isSelected}, r.colorClass]"
        @click='onClick(r.id)'
    ) {{r.name}}
  transition(name="h-slide-fade")
    .flexcontainer-justify-end(v-show='manageMode')
      .btn.btn-default(@click='onCancelClick') Cancel
      .btn.btn-primary(@click='onUpdateClick') Update
</template>

<script>
import Store from './store.js';

export default {
  props: ['representations', 'manageMode'],
  methods: {
    onClick: function(representationId) {
      Store.toggleSelect(representationId)
    },
    onAllClick: function() {
      Store.unselectAll();
    },
    onManageClick: function() {
      Store.setManageMode(true);
    },
    onCancelClick: function() {
      Store.restoreState();
    },
    onUpdateClick: function() {
      Store.updateResourceRepresentations();
    }
  }
}
</script>

<style scoped>

</style>
