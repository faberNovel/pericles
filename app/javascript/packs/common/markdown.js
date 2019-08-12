import Vue from 'vue/dist/vue.esm'
import VueMarkdown from 'vue-markdown'

document.addEventListener('DOMContentLoaded', () => {
  Array.from(document.querySelectorAll('.markdown')).forEach(markdown => {
    new Vue({
      el: markdown,
      components: {
        'vue-markdown': VueMarkdown
      }
    });
  })
});
