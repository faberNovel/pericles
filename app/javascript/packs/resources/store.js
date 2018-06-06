import HttpClient from '../http/client.js';

export default {
  state: {
    displayedResources: [],
    resources: [],
    unusedResources: [],
    projectId: document.location.pathname.split('/')[2],
    treeMode: localStorage.getItem('treeMode') == 'tree',
    query: ''
  },
  client: new HttpClient(),
  init: function() {
    this.state.resources = JSON.parse(localStorage.getItem(this.state.projectId + '/resources') || '[]');
    this.onResourcesChange();
    this.fetchResources().then(() => this.onResourcesChange());
  },
  fetchResources: function() {
    return this.client.fetchResources(this.state.projectId).then((data) => {
      this.state.resources = this.mapDataToViewModel(data);
      localStorage.setItem(this.state.projectId + '/resources', JSON.stringify(this.state.resources));
    });
  },
  mapDataToViewModel: function(data) {
    return data['resources'].map((r) => {
      return {
        id: r.id,
        name: r.name,
        usedResources: r.used_resources,
        hasInvalidMocks: r['has_invalid_mocks?'],
        requestRouteIds: r.request_route_ids,
        responseIds: r.response_ids
      }
    }).sort(
      (a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase())
    );
  },
  onResourcesChange: function() {
    this.applyFilter();
    this.computeUnused();
  },
  toggleTreeMode: function() {
    if (this.state.treeMode) {
      this.deactiveTreeMode();
    } else {
      this.activeTreeMode();
    }
  },
  activeTreeMode: function () {
    this.state.treeMode = true;
    localStorage.setItem('treeMode', 'tree');
  },
  deactiveTreeMode: function () {
    this.state.treeMode = false;
    localStorage.setItem('treeMode', '');
  },
  findResourcesByIds: function(ids) {
    return this.state.resources.filter((r) => ids.indexOf(r.id) !== -1)
  },
  flatChildren: function(resource) {
    let visited = new Set();
    let queue = resource.usedResources.map((r) => r.id);

    while (queue.length > 0) {
      let resourceId = queue.pop();

      if(!visited.has(resourceId)) {
        visited.add(resourceId);
        let resource = this.state.resources.find((r) => r.id === resourceId);
        queue = queue.concat(resource.usedResources.map((r) => r.id));
      }
    }

    return this.state.resources.filter((r) => visited.has(r.id));
  },
  setQuery: function(value) {
    this.state.query = value;
    this.onQueryChange();
  },
  onQueryChange: function() {
    this.applyFilter();
  },
  permissiveQuery: function(query) {
    return query.split('').map((char) => '(' + char.toLowerCase() + ').*').join('');
  },
  isResourceMatchingQuery: function(resource, query) {
    if (query == null || query.length === 0) {
      return false;
    }

    let permissiveQuery = this.permissiveQuery(query);
    let re = new RegExp(permissiveQuery);
    return re.test(resource.name.toLowerCase());
  },
  hasNestedChildrenMatchingQuery: function (resource, query) {
    return this.flatChildren(resource).some(
      (child) => this.isResourceMatchingQuery(child, query)
    );
  },
  applyFilter: function() {
    let q = this.state.query;
    let resources = this.state.resources.filter(
      (r) => r.requestRouteIds.length > 0 || r.responseIds.length > 0
    );
    if (q.length === 0) {
      this.state.displayedResources = resources;
    } else {
      this.state.displayedResources = resources.filter(
        (r) => {
          let isResourceFound = this.isResourceMatchingQuery(r, q);
          let someChildrenFound = this.hasNestedChildrenMatchingQuery(r, q);
          return isResourceFound || someChildrenFound;
        }
      );
    }
  },
  computeUnused: function() {
    let rootResources = this.state.resources.filter(
      (r) => r.requestRouteIds.length > 0 || r.responseIds.length > 0
    );
    let usedResourcesIds = rootResources.map(
      (r) => [r.id, ...this.flatChildren(r).map((res) => res.id)]
    ).reduce((a, b) => a.concat(b), []);

    this.state.unusedResources = this.state.resources.filter(
      (r) => usedResourcesIds.indexOf(r.id) === -1
    );
  }
}