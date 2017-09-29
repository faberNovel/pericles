class RoutesHelperTest < ActionView::TestCase
  setup do
    @route = create(:route)
  end

  test "route_includes_json_schema should return true if route includes a json_schema" do
    @route.request_body_schema = "{}"
    @route.save
    assert route_includes_json_schema(@route)

    @route.request_body_schema = nil
    @route.save
    create(:response, route: @route, body_schema: "{}")
    assert route_includes_json_schema(@route)
  end

  test "route_includes_json_schema should return false if route does not include a json_schema" do
    assert_equal false, route_includes_json_schema(@route)
  end

  test "get_http_method_label_class" do
    assert_equal "label label-success http-method-label", get_http_method_label_class(@route)

    @route.update(http_method: :POST)
    assert_equal "label label-warning http-method-label", get_http_method_label_class(@route)

    @route.update(http_method: :PUT)
    assert_equal "label label-primary http-method-label", get_http_method_label_class(@route)

    @route.update(http_method: :PATCH)
    assert_equal "label label-primary http-method-label", get_http_method_label_class(@route)

    @route.update(http_method: :DELETE)
    assert_equal "label label-danger http-method-label", get_http_method_label_class(@route)
  end
end
