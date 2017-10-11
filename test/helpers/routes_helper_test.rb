class RoutesHelperTest < ActionView::TestCase
  setup do
    @route = create(:route)
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
