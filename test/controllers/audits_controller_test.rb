require 'test_helper'

class AuditsControllerTest < ControllerWithAuthenticationTest
  setup do
    create(:project)
    create(:resource)
    create(:response)
    create(:header)
    create(:resource_representation)
    create(:attribute)
    create(:attributes_resource_representation)
  end

  test 'should get index' do
    assert Audited::Audit.count.positive?

    get audits_path

    assert_response :success
  end
end
