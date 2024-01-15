require "rails_helper"

describe "StripTags: class methods" do
  it "strips tags" do
    expect(StripTags.strip("")).to be_nil
    if Gem::Version.new(Rails.version) >= Gem::Version.new("7.1")
      expect(StripTags.strip("foo<script>alert('xss')</script>")).to eq("fooalert('xss')")
    else
      expect(StripTags.strip("foo<script>alert('xss')</script>")).to eq("foo")
    end
  end

  it "allows empty" do
    expect(StripTags.strip("", allow_empty: true)).to eq("")
    expect(StripTags.strip("<p></p>", allow_empty: true)).to eq("")
  end
end
