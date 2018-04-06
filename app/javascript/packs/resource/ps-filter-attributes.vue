<template lang="pug">
.filter#ps-filter-attributes
  .flexspace-and-center
    div(v-if='!manageMode') Filter by representation :
    div(v-if='manageMode') Manage representations
    transition(name="fade")
      .btn.btn-link(@click='onManageClick'
        v-show='!manageMode'
      ) Manage representations
  .flexwrap
    transition(name="w-slide-fade")
      .btn.representation-btn#all(
        @click='onAllClick'
        v-show="!manageMode"
      ) All
    .btn.representation-btn.flex-v-center(
        v-for='r in representations'
        :id='r.id'
        :class="[{selected: r.isSelected}, r.colorClass]"
        @click='onClick(r.id)'
    )
      .name {{r.name}}
      a(v-if='manageMode'
        @click='onCloneClick(r)'
        style='margin-left: 16px; display: inline-flex;'
      )
        ImageCopy
      a(v-if='manageMode'
        @click='onDeleteClick(r)'
        style='margin-left: 4px; display: inline-flex;'
      )
        ImageDelete

    input.representation-btn#new(
      v-if='manageMode'
      :value='getNewRepresentationName()'
      @input="updateNewRepresentationName"
      placeholder='+ New Representation (press Enter)'
      size='29'
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
</template>

<script>
import ImageDelete from 'images/delete.svg';
import ImageCopy from 'images/copy.svg';
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
      $("#sidebar-wrapper").css('width', '0px');
      $("#wrapper").css('padding-left', '0px');
      Store.setManageMode(true);
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
    onDeleteClick: function(representation) {
      Store.markRepresentationToBeDeleted(representation.id);
    },
    onCloneClick: function(representation) {
      Store.clone(this.activeRepresentation.id);
    }
  },
  computed: {
    newNameWidthStyle: function() {
      let widthValue = '';
      if (this.getNewRepresentationName()) {
        widthValue = Math.max(this.getNewRepresentationName().length * 7, 240) + 'px';
      } else {
        widthValue = 'auto';
      }
      return 'width:' + widthValue + ';';
    }
  },
  components: {
    ImageDelete,
    ImageCopy
  }
}
</script>

<style scoped>
</style>
