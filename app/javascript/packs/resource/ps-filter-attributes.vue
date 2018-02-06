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
    input.representation-btn#new(
      v-if='manageMode'
      :value='getNewRepresentationName()'
      @input="updateNewRepresentationName"
      placeholder='New Representation (press Enter)'
      :size='"New Representation (press Enter)".length'
      :style='newNameWidthStyle'
      @click='onAllClick'
      @keyup.enter='createNewRepresentation'
    )
  transition(name="h-slide-fade")
    .flexcontainer.flex-v-center(v-show='manageMode', style='margin-top: 16px;')
      transition(name="w-slide-fade")
        input.form-control(v-if="activeRepresentation"
          v-model="activeRepresentation.name"
          style='width: 200px;'
        )
      transition(name="w-slide-fade")
        a(href='#'
          style='margin-left: 16px;'
          data-toggle="confirmation"
          @click='onDeleteClick'
        )
          img(v-if="activeRepresentation"
            :src='imageDelete'
          )
      div(style='flex: 1;')
      .btn.btn-default(@click='onCancelClick') Cancel
      .btn.btn-primary(@click='onUpdateClick') Update
</template>

<script>
import imageDelete from 'images/delete.svg';
import Store from './store.js';


export default {
  props: ['representations', 'manageMode', 'activeRepresentation'],
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
    },
    getNewRepresentationName: function() {
      return Store.getNewRepresentationName();
    },
    updateNewRepresentationName: function(e) {
      let name = e.target.value;
      Store.setNewRepresentationName(name);
    },
    createNewRepresentation: function() {
      Store.createNewRepresentation();
    },
    onDeleteClick: function() {
      Store.markRepresentationToBeDeleted(this.activeRepresentation.id);
    }
  }, computed: {
    newNameWidthStyle: function() {
      let widthValue = '';
      if (this.getNewRepresentationName()) {
        widthValue = Math.max(this.getNewRepresentationName().length * 7, 240) + 'px';
      } else {
        widthValue = 'auto';
      }
      return 'width:' + widthValue + ';';
    },
    imageDelete: function() {
      return imageDelete;
    }
  }
}
</script>

<style scoped>
</style>
