export default {
  state: {
    resource: {
      id: '',
      name: '',
      attributes: [],
      representations: [],
    },
    originalResource: {},
    manageMode: false,
    activeRepresentation: null
  },
  fetchResource: function() {
    $.ajax({
      type: "GET",
      url: document.location.href + '.json',
      contentType: "application/json",
    }).then((data) => {
      let viewModel = this.mapDataToViewModel(data);
      Object.assign(this.state.originalResource, JSON.parse(JSON.stringify(viewModel)));
      Object.assign(this.state.resource, viewModel);
    });
  },
  mapDataToViewModel: function(data) {
    return {
      id: data.resource.id,
      name: data.resource.name,
      attributes: data.resource.resource_attributes.map((a) =>
        this.mapResourceAttributeToViewModel(a, data.resource.resource_representations)
      ),
      representations: data.resource.resource_representations.map((r, i) =>
        Object.assign({}, {
          id: r.id,
          name: r.name,
          colorClass: 'color-' + i,
          isSelected: false
        })
      )
    };
  },
  mapResourceAttributeToViewModel: function(attribute, resourceRepresentationsData) {
    return Object.assign({}, {
      id: attribute.id,
      name: attribute.name,
      type: attribute.readable_type,
      displayedType: attribute.readable_type,
      resourceId: attribute.resource_id,
      scheme: attribute.scheme,
      minimum: attribute.minimum,
      maximum: attribute.maximum,
      minItems: attribute.min_items,
      maxItems: attribute.max_items,
      description: attribute.description,
      nullable: attribute.nullable,
      isArray: attribute.is_array,
      availableRepresentations: attribute.available_resource_representations,
      isDisplayed: true,
      representations: resourceRepresentationsData.map((r, i) => {
        let association = r.attributes_resource_representations
          .find((arr) => arr.attribute_id === attribute.id);
        return {
          id: r.id,
          associationId: association && association.id,
          customKeyName: association && association.custom_key_name,
          isRequired: (association == null) ? true : association.is_required,
          isNull: association && association.is_null,
          hasAttribute: !!association,
          colorClass: 'color-' + i,
          resourceRepresentationName: association && association.resource_representation_name,
          selectedRepresentationId: this.getDefaultSelectedRepresentationId(attribute, association)
        }
      })
    });
  },
  toggleSelect: function(representationId) {
    if (this.state.manageMode) {
      this.unselectAll();
    }

    let representation = this.state.resource.representations
      .find((r) => r.id === representationId);
    representation.isSelected = !representation.isSelected;

    this.updateStateAfterSelectionChanged();
  },
  unselectAll: function() {
    const resource = this.state.resource;
    resource.representations = resource.representations.map((r) =>
      Object.assign({}, r, {isSelected: false})
    );

    this.updateStateAfterSelectionChanged();
  },
  setManageMode: function(boolean) {
    this.state.manageMode = boolean;
    let representations = this.state.resource.representations
    if (representations.filter((r) => r.isSelected).length > 1) {
      this.unselectAll();
    }
  },
  restoreState: function() {
    Object.assign(this.state.resource, JSON.parse(JSON.stringify(this.state.originalResource)));
  },
  toggleBelongingAttribute: function(attributeId, representationId) {
    let attribute = this.state.resource.attributes.find((a) => a.id === attributeId);
    let representation = attribute.representations.find(
      (r) => r.id === representationId
    );
    representation.hasAttribute = !representation.hasAttribute;
  },
  computeIsDislayedForAttributes: function() {
    let attributes = this.state.resource.attributes;
    let activeRepresentations = this.state.resource.representations.filter(
      (r) => r.isSelected
    );

    if(activeRepresentations.length === 0) {
      attributes.forEach((a) => a.isDisplayed = true);
    }

    attributes.forEach((a) => {
      let representationsWithAttribute = a.representations.filter((r) => r.hasAttribute);
      a.isDisplayed = activeRepresentations.every((activeRep) =>
        representationsWithAttribute.find((r) => r.id === activeRep.id)
      )
    });
  },
  computeDisplayedTypeForAttributes: function() {
    let attributes = this.state.resource.attributes;

    if (this.state.activeRepresentation) {
      attributes.forEach((a) => {
        let repViewModel = a.representations.find((r) => r.id === this.state.activeRepresentation.id);
        if (!repViewModel.resourceRepresentationName) {
          return a.displayedType = a.type;
        }

        a.displayedType = repViewModel.resourceRepresentationName;
        if (a.isArray) {
          a.displayedType = 'Array<' + a.displayedType + '>';
        }
      });
    } else {
      attributes.forEach((a) => a.displayedType = a.type);
    }
  },
  computeActiveRepresentation: function() {
    let activeRepresentations = this.state.resource.representations.filter(
      (r) => r.isSelected
    );
    if (activeRepresentations.length === 1) {
      this.state.activeRepresentation = activeRepresentations[0];
    } else {
      this.state.activeRepresentation = null;
    }
  },
  updateStateAfterSelectionChanged: function() {
    this.computeActiveRepresentation();
    this.computeIsDislayedForAttributes();
    this.computeDisplayedTypeForAttributes();
  },
  updateResourceRepresentations: function() {
    let resource = this.state.resource;
    let promises = resource.representations.map((rep) => {
      let id = rep.id;
      let data = Object.assign({}, {
        name: rep.name,
        description: rep.description,
        attributes_resource_representations_attributes: resource.attributes.map(
          (a) => {
            let representationVM = a.representations.find((r) => r.id === rep.id);
            return {
              id: representationVM.associationId,
              custom_key_name: representationVM.customKeyName,
              is_required: representationVM.isRequired,
              is_null: representationVM.isNull,
              attribute_id: a.id,
              resource_representation_id: representationVM.selectedRepresentationId,
              _destroy: !representationVM.hasAttribute
            };
        })
      });

      return $.ajax({
        type: "PUT",
        url: "/resources/" + resource.id + "/resource_representations/" + id,
        data: JSON.stringify({resource_representation: data}),
        contentType: "application/json",
        dataType: "json"
      });
    });

    // TODO: catch error
    Promise.all(promises).finally(() => {
      this.fetchResource();
      this.state.manageMode = false;
    });
  },
  getDefaultSelectedRepresentationId: function(attributeData, association) {
    let selectedRepresentationId = association && association.resource_representation_id;
    let availableReps = attributeData.available_resource_representations;
    let defaultRepresentation = availableReps && availableReps[0];
    return selectedRepresentationId || (defaultRepresentation && defaultRepresentation.id);
  },
  setSelectedRepresentation(attributeId, newSelectedRepresentation) {
    let a = this.state.resource.attributes.find((a) => a.id === attributeId);
    let r  = a.representations.find((r) => r.id === this.state.activeRepresentation.id);
    r.selectedRepresentationId = newSelectedRepresentation.id;
  }
}