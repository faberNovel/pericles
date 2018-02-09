import 'core-js/fn/promise/finally';

import Vue from 'vue/dist/vue.esm'

import Store from './store.js';
import FilterAttributesComponent from './ps-filter-attributes.vue';
import AttributesComponent from './ps-attributes.vue';


document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#root-vue',
    data: Store.state,
    components: {
      'ps-filter-attributes': FilterAttributesComponent,
      'ps-attributes': AttributesComponent
    }
  });

  Store.fetchResource();
});