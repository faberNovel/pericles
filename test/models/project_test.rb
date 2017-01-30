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

  test "shouldn't exist without a description that's too long" do
    assert_not build(:project, description: "testtesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttesttest
      testtesttesttesttesttesttesttesttest").valid?
  end

  test "Project should be valid with all attributes set correctly" do
    assert build(:project, title: "New Project", description: "Project description").valid?
  end
end
