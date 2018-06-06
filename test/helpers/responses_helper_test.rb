require 'test_helper'

class ResponsesHelperTest < ActionView::TestCase
  test 'response_status_code_class' do
    assert_equal 'valid-response', response_status_code_class(200)
    assert_equal 'valid-response', response_status_code_class(201)
    assert_equal 'valid-response', response_status_code_class(302)

    assert_equal 'invalid-response', response_status_code_class(400)
    assert_equal 'invalid-response', response_status_code_class(422)
    assert_equal 'invalid-response', response_status_code_class(500)
  end

  test 'schema_summary' do
    assert_equal '', schema_summary('', nil, true)
    assert_equal '', schema_summary('', build(:resource_representation, name: ''), true)

    rep = build(:resource_representation, name: 'UserDetailed')
    rep_link = link_to(
      rep.name,
      project_resource_path(rep.resource.project, rep.resource, anchor: "rep-#{rep.id}")
    )

    assert_equal "{ \"user\": #{rep_link} }", schema_summary('user', rep, false)
    assert_equal "{ \"user\": [ #{rep_link} ] }", schema_summary('user', rep, true)
    assert_equal "{ #{rep_link} }", schema_summary('', rep, false)
    assert_equal "[ #{rep_link} ]", schema_summary('', rep, true)
  end
end
