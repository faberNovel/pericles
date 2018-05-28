class RoutesHelperTest < ActionView::TestCase
  setup do
    @route = create(:route)
  end

  test 'label_class_for_http_method' do
    assert_equal 'label label-success http-method-label', label_class_for_http_method(@route.http_method)

    @route.update(http_method: :POST)
    assert_equal 'label label-warning http-method-label', label_class_for_http_method(@route.http_method)

    @route.update(http_method: :PUT)
    assert_equal 'label label-primary http-method-label', label_class_for_http_method(@route.http_method)

    @route.update(http_method: :PATCH)
    assert_equal 'label label-primary http-method-label', label_class_for_http_method(@route.http_method)

    @route.update(http_method: :DELETE)
    assert_equal 'label label-danger http-method-label', label_class_for_http_method(@route.http_method)
  end
end
