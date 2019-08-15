import Vue from "vue/dist/vue.esm"
import ResourceInstanceEditor from "./ps-resource-instance-editor"

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#resource-instance-editor',
    components: { 'ps-resource-instance-editor': ResourceInstanceEditor },
  })
})