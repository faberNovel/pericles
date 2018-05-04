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
    PsRepresentationBtn(
      v-for='r in representations'
      :representation='r'
      :manageMode='manageMode'
    )

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
</template>

<script>
import PsRepresentationBtn from './ps-representation-btn.vue';
import Store from './store.js';


export default {
  props: ['representations', 'manageMode', 'activeRepresentation'],
  methods: {
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
    PsRepresentationBtn
  }
}
</script>

<style scoped>
</style>
