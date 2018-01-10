require 'test_helper'

class ProjectRelatedPolicyTest < ActiveSupport::TestCase
  setup do
    @project = create(:project)
    @user = create(:user)
    @resource = create(:resource, project: @project)
  end

  test "project related policy works only with record" do
    assert_not ProjectRelatedPolicy.new(@user, Resource).show?
    assert_not ProjectRelatedPolicy.new(@user, Resource).create?
    assert_not ProjectRelatedPolicy.new(@user, Resource).new?
    assert_not ProjectRelatedPolicy.new(@user, Resource).update?
    assert_not ProjectRelatedPolicy.new(@user, Resource).edit?
    assert_not ProjectRelatedPolicy.new(@user, Resource).destroy?
  end

  test "interal user can see related records" do
    assert ProjectRelatedPolicy.new(@user, @resource).show?
  end

  test "non-member external user cannot see related records" do
    @user = create(:user, :external)
    assert_not ProjectRelatedPolicy.new(@user, @resource).show?
  end

  test "member external user can see related records" do
    @user = create(:user, :external)
    create(:member, project: @project, user: @user)
    assert ProjectRelatedPolicy.new(@user, @resource).show?
  end

  test "external user can see related records of public project" do
    @user = create(:user, :external)
    @project.update(is_public: true)
    assert ProjectRelatedPolicy.new(@user, @resource).show?
  end

  test "internal user have write permission" do
    assert ProjectRelatedPolicy.new(@user, @resource).create?
    assert ProjectRelatedPolicy.new(@user, @resource).new?
    assert ProjectRelatedPolicy.new(@user, @resource).update?
    assert ProjectRelatedPolicy.new(@user, @resource).edit?
    assert ProjectRelatedPolicy.new(@user, @resource).destroy?
  end

  test "non-member external user does not have write permission" do
    @user = create(:user, :external)
    assert_not ProjectRelatedPolicy.new(@user, @resource).create?
    assert_not ProjectRelatedPolicy.new(@user, @resource).new?
    assert_not ProjectRelatedPolicy.new(@user, @resource).update?
    assert_not ProjectRelatedPolicy.new(@user, @resource).edit?
    assert_not ProjectRelatedPolicy.new(@user, @resource).destroy?
  end

  test "member external user have write permission" do
    @user = create(:user, :external)
    create(:member, project: @project, user: @user)
    assert ProjectRelatedPolicy.new(@user, @resource).create?
    assert ProjectRelatedPolicy.new(@user, @resource).new?
    assert ProjectRelatedPolicy.new(@user, @resource).update?
    assert ProjectRelatedPolicy.new(@user, @resource).edit?
    assert ProjectRelatedPolicy.new(@user, @resource).destroy?
  end

  test "unauthenticated user does not have read permission" do
    assert_not ProjectRelatedPolicy.new(nil, @resource).show?
  end

  test "unauthenticated user can see related records of public project" do
    @project.update(is_public: true)
    assert ProjectRelatedPolicy.new(nil, @resource).show?
  end

  test "unauthenticated user does not have write permission" do
    assert_not ProjectRelatedPolicy.new(nil, @resource).create?
    assert_not ProjectRelatedPolicy.new(nil, @resource).new?
    assert_not ProjectRelatedPolicy.new(nil, @resource).update?
    assert_not ProjectRelatedPolicy.new(nil, @resource).edit?
    assert_not ProjectRelatedPolicy.new(nil, @resource).destroy?
  end
end
