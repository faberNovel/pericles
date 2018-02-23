export default class Client {
  constructor() {
  }

  fetchResources(projectId) {
    return $.ajax({
      type: "GET",
      url: '/projects/' + projectId + '/resources.json',
      contentType: "application/json",
    });
  }

  fetchResource(projectId, resourceId) {
    return $.ajax({
      type: "GET",
      url: '/projects/' + projectId + '/resources/' + resourceId + '.json',
      contentType: "application/json",
    });
  }

  updateResourceRepresentation(resourceId, representationId, restData) {
    return $.ajax({
      type: "PUT",
      url: "/resources/" + resourceId + "/resource_representations/" + representationId,
      data: JSON.stringify({resource_representation: restData}),
      contentType: "application/json",
      dataType: "json"
    });
  }

  createNewRepresentation(resourceId, representationName) {
    return $.ajax({
      type: "POST",
      url: "/resources/" + resourceId + "/resource_representations",
      contentType: "application/json",
      data: JSON.stringify({resource_representation: {name: representationName}}),
      dataType: "json"
    });
  }

  deleteRepresentation(resourceId, representationId) {
    return $.ajax({
      type: "DELETE",
      url: "/resources/" + resourceId + "/resource_representations/" + representationId,
      contentType: "application/json",
    });
  }

  cloneRepresentation(resourceId, representationId) {
    return $.ajax({
      type: "POST",
      url: "/resources/" +resourceId + "/resource_representations/" + representationId + '/clone',
      contentType: "application/json",
    });
  }
}