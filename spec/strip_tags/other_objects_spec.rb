require "spec_helper"

class CoexistWithOtherObjects < Tableless
  attr_accessor :arr, :hsh, :str

  strip_tags

  def initialize
    @arr, @hsh, @str = [], {}, "foo<script>alert('xss')</script>"
  end

  def attributes
    {arr: arr, hsh: hsh, str: str}
  end
end

describe "StripTagsL other objects" do
  it "allows other empty objects" do
    record = CoexistWithOtherObjects.new
    record.valid?
    expect(record.arr).to eq([])
    expect(record.hsh).to eq({})
    expect(record.str).to eq("foo")
  end
end
