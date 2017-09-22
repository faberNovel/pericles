require 'test_helper'

class SchemeTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:scheme, name: nil).valid?
  end

  test "set scheme to null if destroyed" do
    s = create(:scheme)
    a = create(:attribute, primitive_type: :string, scheme: s)
    assert s.destroy
    assert_not a.reload.scheme
  end

  test "is pattern if regexp is set" do
    s = create(:scheme, regexp: 'cool')
    assert s.pattern?
  end

  test 'is format if regexp is not set' do
    s = create(:scheme, regexp: nil)
    assert s.format?
  end
end
