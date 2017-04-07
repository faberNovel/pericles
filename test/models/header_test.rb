require 'test_helper'

class HeaderTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:header, name: nil).valid?
  end

  test "shouldn't exist without a http_message" do
    assert_not build(:header, http_message: nil).valid?
  end

  test "Two headers within the same http_message shouldn't have the same name" do
    header = create(:header)
    name = header.name
    http_message = header.http_message
    assert_not build(:header, name: name, http_message: http_message).valid?
    assert_not build(:header, name: name.upcase, http_message: http_message).valid?
  end

  test "Header should be valid with all attributes set correctly" do
    assert build(:header, name: "Content-Type", description: "New test header").valid?
  end
end
