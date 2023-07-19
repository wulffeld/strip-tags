require "spec_helper"

describe "StripTags: class methods" do
  it "strips tags" do
    expect(StripTags.strip("")).to be_nil
    expect(StripTags.strip("foo<script>alert('xss')</script>")).to eq("foo")
  end

  it "allows empty" do
    expect(StripTags.strip("", allow_empty: true)).to eq("")
    expect(StripTags.strip("<p></p>", allow_empty: true)).to eq("")
  end
end
