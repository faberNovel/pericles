require 'test_helper'

class MetadatumTest < ActiveSupport::TestCase
  test "shouldn't exist without a name" do
    assert_not build(:metadatum, name: nil).valid?
  end

  test "shouldn't exist without a primitive_type" do
    assert_not build(:metadatum, primitive_type: nil).valid?
  end

  test "shouldn't exist without a project" do
    assert_not build(:metadatum, project: nil).valid?
  end

  test "Two Metadata within the same project shouldn't have the same name" do
    metadatum = create(:metadatum)
    assert_not build(:metadatum, name: metadatum.name, project: metadatum.project).valid?
    assert build(:metadatum, name: metadatum.name.upcase, project: metadatum.project).valid?
  end
end
