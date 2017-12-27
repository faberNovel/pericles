require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
  test "shouldn't exist without a title" do
    assert_not build(:project, title: nil).valid?
  end

  test "Two projects shouldn't have the same title" do
    create(:project, title: "NOK")
    assert_not build(:project, title: "NOK").valid?
  end

  test "shouldn't exist with a title that's too short or too long" do
    assert_not build(:project, title: "a").valid?
    assert_not build(:project, title: "testtesttesttesttesttesttesttesttesttesttest").valid?
  end

  test "Project should be valid with all attributes set correctly" do
    assert build(:project, title: "New Project", description: "Project description").valid?
  end

  test "created projects have a mock profile" do
    project = create(:project, title: "New Project", description: "Project description")
    assert_equal project.mock_profiles.count, 1
  end

  test 'of user' do
    user = create(:user)

    his_project = create(:project)
    create(:member, user: user, project: his_project)

    not_his_project = create(:project)
    create(:member, user: create(:user), project: not_his_project)

    _no_one_project = create(:project)

    assert_equal [his_project], Project.of_user(user)
  end
end
