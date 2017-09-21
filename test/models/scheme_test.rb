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
end
