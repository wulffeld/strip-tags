require "spec_helper"

module MockAttributes
  def self.included(base)
    base.attribute :frozen
  end
end

class StripAllMockRecord < Tableless
  include MockAttributes
  strip_tags
end

describe "StripTags: skips frozen" do
  it "skips frozen values" do
    record = StripAllMockRecord.new(frozen: "foo<script>alert('xss')</script>".freeze)
    record.valid?
    expect(record.frozen).to eq("foo<script>alert('xss')</script>")
  end
end
