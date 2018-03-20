require 'test_helper'

class SearchServiceTest < ActiveSupport::TestCase
  setup do
    @project = create(:project)
    @service = SearchService.new(@project)
  end

  test 'search api_error_instances' do
    assert @service.search_api_error_instances('query that match noting').empty?

    search_target = create(:api_error_instance)
    search_target.api_error.update(project: @project)
    search_result = @service.search_api_error_instances(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search api_errors' do
    assert @service.search_api_errors('query that match noting').empty?

    search_target = create(:api_error)
    search_target.update(project: @project)
    search_result = @service.search_api_errors(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search attributes' do
    assert @service.search_attributes('query that match noting').empty?

    search_target = create(:attribute)
    search_target.parent_resource.update(project: @project)
    search_result = @service.search_attributes(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search response_headers' do
    assert @service.search_response_headers('query that match noting').empty?

    response = create(:response,
      route: create(:route,
        resource: create(:resource,
          project: @project
        )
      )
    )
    search_target = create(:header, http_message: response)
    search_result = @service.search_response_headers(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search request_headers' do
    assert @service.search_request_headers('query that match noting').empty?

    route = create(:route,
      resource: create(:resource,
        project: @project
      )
    )
    search_target = create(:header, http_message: route)
    search_result = @service.search_request_headers(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search metadata' do
    assert @service.search_metadata('query that match noting').empty?

    search_target = create(:metadatum)
    search_target.update(project: @project)
    search_result = @service.search_metadata(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search metadatum_instances' do
    assert @service.search_metadatum_instances('query that match noting').empty?

    search_target = create(:metadatum_instance)
    search_target.metadatum.update(project: @project)
    search_result = @service.search_metadatum_instances(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search mock_pickers' do
    assert @service.search_mock_pickers('query that match noting').empty?

    search_target = create(:mock_picker)
    search_target.mock_profile.update(project: @project)
    search_result = @service.search_mock_pickers(search_target.body_pattern)

    assert_equal [search_target], search_result
  end

  test 'search mock_profiles' do
    assert @service.search_mock_profiles('query that match noting').empty?

    search_target = create(:mock_profile)
    search_target.update(project: @project)
    search_result = @service.search_mock_profiles(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search project' do
    assert @service.search_project('query that match noting').empty?

    search_target = @project
    search_result = @service.search_project(search_target.description)

    assert_equal [search_target], search_result
  end

  test 'search query_parameters' do
    assert @service.search_query_parameters('query that match noting').empty?

    search_target = create(:query_parameter)
    search_target.route.resource.update(project: @project)
    search_result = @service.search_query_parameters(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search reports' do
    assert @service.search_reports('query that match noting').empty?

    search_target = create(:report)
    search_target.update(project: @project)
    search_result = @service.search_reports(search_target.url)

    assert_equal [search_target], search_result
  end

  test 'search resource_instances' do
    assert @service.search_resource_instances('query that match noting').empty?

    search_target = create(:resource_instance)
    search_target.resource.update(project: @project)
    search_result = @service.search_resource_instances(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search resource_representations' do
    assert @service.search_resource_representations('query that match noting').empty?

    search_target = create(:resource_representation)
    search_target.resource.update(project: @project)
    search_result = @service.search_resource_representations(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search resources' do
    assert @service.search_resources('query that match noting').empty?

    search_target = create(:resource)
    search_target.update(project: @project)
    search_result = @service.search_resources(search_target.name)

    assert_equal [search_target], search_result
  end

  test 'search responses' do
    assert @service.search_responses('query that match noting').empty?

    search_target = create(:response, root_key: 'I <3 tests')
    search_target.route.resource.update(project: @project)
    search_result = @service.search_responses(search_target.root_key)

    assert_equal [search_target], search_result
  end

  test 'search routes' do
    assert @service.search_routes('query that match noting').empty?

    search_target = create(:route)
    search_target.resource.update(project: @project)
    search_result = @service.search_routes(search_target.url)

    assert_equal [search_target], search_result
  end

  test 'search validation_errors' do
    assert @service.search_validation_errors('query that match noting').empty?

    search_target = create(:validation_error)
    search_target.report.update(project: @project)
    search_result = @service.search_validation_errors(search_target.description)

    assert_equal [search_target], search_result
  end
end
