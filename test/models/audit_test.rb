require 'test_helper'

class AuditTest < ActiveSupport::TestCase
  test "project scope" do
    project = create(:project)
    assert_difference -> { Audited::Audit.of_project(project).count }, 2 do
      create(:resource, project: project)
    end
  end
end
