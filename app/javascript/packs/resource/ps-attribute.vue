<template lang="pug">
.table-row.flexwrap(v-if='attribute.isDisplayed')
  .table-row
    .cell(v-if='activeAttributeRepresentation && activeAttributeRepresentation.customKeyName',
        :class='activeRepresentation.colorClass',
        style='font-weight: 700;'
    )
      .tool-tip(data-toggle='tooltip'
        data-placement='top'
        :title='attribute.name'
      ) {{displayedName}}
    .cell(v-else) {{displayedName}}
    .cell.type(v-if='manageMode && attribute.resourceId && activeRepresentation')
      v-select(v-model='selected', :options='attribute.availableRepresentations', label='name')
    .cell.type(v-else-if='attribute.resourceId')
      a(:href='resourcePath(attribute.resourceId)') {{displayedType}}
    .cell.type(v-else) {{displayedType}}
    .cell {{attribute.nullable}}
    .cell.circles
      .circle(v-for='r in attribute.representations'
        :class="[{selected: r.hasAttribute, hoverable: manageMode}, r.colorClass]"
        @click='toggleBelongingAttribute(attribute.id, r.id)'
      )
    .cell
      a(
        v-show='shouldShowConstraintCollapse'
        data-toggle='collapse'
        :href="'#collapse-attribute-' + attribute.id"
        class='collapsed'
      ) ▾
      a(
        v-show='shouldShowRepresentationCollapse'
        data-toggle='collapse'
        :href="'#collapse-representation-' + attribute.id"
        class='collapsed'
      ) ▾
  .contraints-row.collapse(:id="'collapse-attribute-' + attribute.id"
    v-show='!manageMode'
  )
    .constraint-cell(v-if='attribute.enum')
      dt Enum
      dd {{attribute.enum}}
    .constraint-cell(v-if='!(attribute.scheme == undefined)')
      dt Scheme
      dd {{attribute.scheme.name}}
    .constraint-cell(v-if='!(attribute.minimum == undefined)')
      dt Minimum
      dd {{attribute.minimum}}
    .constraint-cell(v-if='!(attribute.maximum == undefined)')
      dt Maximum
      dd {{attribute.maximum}}
    .constraint-cell(v-if='!(attribute.minItems == undefined)')
      dt Min Items
      dd {{attribute.minItems}}
    .constraint-cell(v-if='!(attribute.maxItems == undefined)')
      dt Max Items
      dd {{attribute.maxItems}}
    .constraint-cell.description(v-if='attribute.description')
      dt Description
      dd {{attribute.description}}
  .contraints-row.collapse(:id="'collapse-representation-' + attribute.id"
    v-if='manageMode && activeAttributeRepresentation'
  )
    .constraint-cell
      input.form-control(placeholder='Custom key name', v-model='activeAttributeRepresentation.customKeyName')
    .constraint-cell
      .checkbox
        label
          input(type='checkbox', v-model='activeAttributeRepresentation.isRequired')
          .
            Required?
    .constraint-cell
      .checkbox
        label
          input(type='checkbox', v-model='activeAttributeRepresentation.isNull')
          .
            Is null?
</template>

<script>
import vSelect from 'vue-select';
import Store from './store.js';

export default {
  props: ['attribute', 'manageMode', 'activeRepresentation'],
  methods: {
    toggleBelongingAttribute: function(attributeId, representationId) {
        if(!this.manageMode)
            return;

        Store.toggleBelongingAttribute(attributeId, representationId);
    },
    resourcePath: function(resourceId) {
      let baseUrl = document.location.pathname.split('/').slice(0, -1).join('/');
      let url = baseUrl + '/' + resourceId;
      if (this.activeAttributeRepresentation && this.activeAttributeRepresentation.selectedRepresentationId != null) {
        url += '#rep-' + this.activeAttributeRepresentation.selectedRepresentationId
      }
      return url;
    }
  },
  computed: {
    shouldShowConstraintCollapse: function() {
      let a = this.attribute;
      const empty = (v) => (v == undefined || v.length === 0); // 0 is not empty
      return !this.manageMode && !(
        empty(a.enum) && empty(a.scheme) && empty(a.minimum) &&
        empty(a.maximum) && empty(a.minItems) && empty(a.maxItems) &&
        empty(a.description)
      );
    },
    shouldShowRepresentationCollapse: function() {
      return this.manageMode && this.activeAttributeRepresentation;
    },
    selected: {
      get: function () {
        if (!this.activeRepresentation) {
          return null;
        }
        let selected = this.attribute.availableRepresentations.find((r) =>
          r.id === this.activeAttributeRepresentation.selectedRepresentationId
        );
        return selected;
      },
      set: function (representation) {
        // Wait for next release of vue-select (^2.4.0)
        // so we can no longer unselect the representation
        // and remove this guard
        if(representation) {
          Store.setSelectedRepresentation(this.attribute.id, representation);
        }
      }
    },
    activeAttributeRepresentation: function() {
      if (!this.activeRepresentation) {
        return null;
      }
      return this.attribute.representations.find((r) => r.id === this.activeRepresentation.id);
    },
    displayedType: function() {
      let rep = this.activeAttributeRepresentation;

      if (rep && rep.isNull) {
        return 'null';
      } else {
        return this.attribute.displayedType;
      }
    },
    displayedName: function() {
      let rep = this.activeAttributeRepresentation;
      let name = this.attribute.name;

      if (rep && rep.customKeyName) {
        name = rep.customKeyName;
      }

      if (rep && !rep.isRequired) {
        name += ' (optional)'
      }

      return name;
    }
  },
  components: {'v-select': vSelect}
}
</script>

<style scoped>
</style>
