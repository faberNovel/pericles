require 'test_helper'

class ProjectTest < ActiveSupport::TestCase
	test "shouldn't exist without a title" do
		assert_not build(:project, title: nil).valid?
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
end
