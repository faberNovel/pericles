<template lang="pug">
div(v-if='resources && resources.length > 0')
  h3 Unused Resources

  .list.margin-top-element
    ps-resource(
      v-for='resource in resources'
      :resource='resource'
      depth='0'
    )
</template>

<script>
import ResourceComponent from './ps-resource.vue';

export default {
  props: ['resources'],
  components: {'ps-resource': ResourceComponent}
}
</script>

<style scoped>
</style>
