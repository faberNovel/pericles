class ResponsesHelperTest < ActionView::TestCase

  test 'response_status_code_class' do
    assert_equal 'valid-response', response_status_code_class(200)
    assert_equal 'valid-response', response_status_code_class(201)
    assert_equal 'valid-response', response_status_code_class(302)

    assert_equal 'invalid-response', response_status_code_class(400)
    assert_equal 'invalid-response', response_status_code_class(422)
    assert_equal 'invalid-response', response_status_code_class(500)
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
