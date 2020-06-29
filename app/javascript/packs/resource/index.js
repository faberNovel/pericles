import 'core-js/fn/promise/finally';

import Vue from 'vue/dist/vue.esm'
import VueMarkdown from 'vue-markdown'

import Store from './store.js';
import FilterAttributesComponent from './ps-filter-attributes.vue';
import AttributesComponent from './ps-attributes.vue';
import CodeButtonsComponent from './ps-code-buttons.vue';


document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#resource-show',
    data: Store.state,
    components: {
      'ps-filter-attributes': FilterAttributesComponent,
      'ps-attributes': AttributesComponent,
      'ps-code-buttons': CodeButtonsComponent,
      'vue-markdown': VueMarkdown,
    },
    methods: {
      onCancelClick: function() {
        $("#sidebar-wrapper").css('width', '');
        $("#wrapper").css('padding-left', '');
        Store.restoreState();
      },
      onUpdateClick: function() {
        $("#sidebar-wrapper").css('width', '');
        $("#wrapper").css('padding-left', '');
        Store.updateResourceRepresentations();
      },
    }
  });

  Store.fetchResource();

  $(document).ready(function() {
    $("select").chosen({search_contains: true, width: '100%'});
    activate_tab_if_anchor_present()
  });

  function activate_tab_if_anchor_present(){
    var url = window.location.href
    var idx = url.indexOf("#");
    if (idx !== -1) {
      var tab = url.substring(idx + 1);
      $('.nav.nav-pills a[href="#' + tab + '"]').tab('show');
    };
  };
});
