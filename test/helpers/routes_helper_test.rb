class RoutesHelperTest < ActionView::TestCase
  setup do
    @route = create(:route)
  end

  test "label_class_for_http_method" do
    assert_equal "label label-success http-method-label", label_class_for_http_method(@route.http_method)

    @route.update(http_method: :POST)
    assert_equal "label label-warning http-method-label", label_class_for_http_method(@route.http_method)

    @route.update(http_method: :PUT)
    assert_equal "label label-primary http-method-label", label_class_for_http_method(@route.http_method)

    @route.update(http_method: :PATCH)
    assert_equal "label label-primary http-method-label", label_class_for_http_method(@route.http_method)

    @route.update(http_method: :DELETE)
    assert_equal "label label-danger http-method-label", label_class_for_http_method(@route.http_method)
  end

  test "schema_summary" do
    assert_equal '', schema_summary("", nil, true)
    assert_equal '', schema_summary("", '', true)

    assert_equal '{ "user": UserDetailed }', schema_summary("user", 'UserDetailed', false)
    assert_equal '{ "user": [ UserDetailed ] }', schema_summary("user", 'UserDetailed', true)
    assert_equal '{ UserDetailed }', schema_summary("", 'UserDetailed', false)
    assert_equal '[ UserDetailed ]', schema_summary("", 'UserDetailed', true)
  end
end
