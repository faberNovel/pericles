class ValidationsHelperTest < ActionView::TestCase
  test "format_json_text should return a pretty json if text is valid json" do
    json = "{}"
    parsed_json = JSON.parse(json)
    expected = JSON.pretty_generate(parsed_json)
    assert_equal expected, format_json_text(json)
  end

  test "format_json_text should return the input text if not valid json" do
    text = "{ abcdefg }"
    assert_equal text, format_json_text(text)
  end
end