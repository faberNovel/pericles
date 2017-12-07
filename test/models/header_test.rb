require 'test_helper'

class HeaderTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:header, name: nil).valid?
  end

  test "shouldn't exist without a http_message" do
    assert_not build(:header, http_message: nil).valid?
  end

  test "Header should be valid with all attributes set correctly" do
    assert build(:header, name: "Content-Type").valid?
  end
end
