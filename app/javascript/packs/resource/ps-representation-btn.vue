<template lang="pug">
.btn.representation-btn.flex-v-center(
    :id='representation.id'
    :class="[{selected: representation.isSelected}, representation.colorClass]"
    @click='onClick(representation.id)'
)
  input.form-control(v-show="isEditing"
    v-model="representation.name"
    ref="nameInput"
    @blur='isEditing = false'
    @click='$event.stopPropagation()'
    :style='"width: " + representation.name.length + "ch;"'
  )
  .name(v-if="!isEditing") {{representation.name}}
  a(v-if='manageMode'
    @click='onEditClick($event)'
    style='margin-left: 16px; display: inline-flex;'
  )
    ImageEdit
  a(v-if='manageMode'
    @click='onCloneClick($event)'
    style='margin-left: 4px; display: inline-flex;'
  )
    ImageCopy
  a(v-if='manageMode'
    @click='onDeleteClick($event)'
    style='margin-left: 4px; display: inline-flex;'
  )
    ImageDelete
</template>

<script>
import Vue from 'vue/dist/vue.esm'

import ImageDelete from 'images/delete.svg';
import ImageCopy from 'images/copy.svg';
import ImageEdit from 'images/edit.svg';
import Store from './store.js';


export default {
  props: ['representation', 'manageMode'],
  methods: {
    onClick: function(representationId) {
      Store.toggleSelect(representationId)
    },
    onDeleteClick: function(event) {
      if (event) {
        event.stopPropagation();
      }
      if (this.representation.used_in_resource_representations.length > 0) {
        alert(
          'Used in ' +
          this.representation.used_in_resource_representations.join(', ') +
          ' resource representation(s)'
        );
      } else {
        Store.markRepresentationToBeDeleted(this.representation.id);
      }
    },
    onCloneClick: function(event) {
      if (event) {
        event.stopPropagation();
      }
      Store.clone(this.representation.id);
    },
    onEditClick: function(event) {
      if (event) {
        event.stopPropagation();
      }
      this.isEditing = true;
      var self = this;
      Vue.nextTick(function () {
        self.$refs.nameInput.focus();
      });
    }
  },
  data: function() {
    return {
      isEditing: false
    }
  },
  components: {
    ImageDelete,
    ImageCopy,
    ImageEdit
  }
}
</script>

<style scoped>
</style>
