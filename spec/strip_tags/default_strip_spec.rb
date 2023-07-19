require "spec_helper"

module MockAttributes
  def self.included(base)
    base.attribute :foo
    base.attribute :bar
    base.attribute :moo
  end
end

class StripAllMockRecord < Tableless
  include MockAttributes
  strip_tags
end


describe "StripTags: defaults" do
  before(:each) do
    @init_params = {
      foo: "foo> & < <script>alert('xss')</script>",
      bar: "<script>alert('xss')</script>bar",
      moo: "moo<script>alert('xss')</script>"
    }
  end

  it "strips all fields" do
    record = StripAllMockRecord.new(@init_params)
    record.valid?
    expect(record.foo).to eq("foo> & < ")
    expect(record.bar).to eq("bar")
    expect(record.moo).to eq("moo")
  end
end
