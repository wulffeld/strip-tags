require "rails_helper"

module MockAttributes
  def self.included(base)
    base.attribute :foo
    base.attribute :bar
  end
end

class StripAllowEmpty < Tableless
  include MockAttributes
  strip_tags allow_empty: true
end

describe "StripTags: allow empty" do
  before(:each) do
    @init_params = {
      foo: "foo<script>alert('xss')</script>",
      bar: "",
    }
  end

  it "strips and allow empty" do
    record = StripAllowEmpty.new(@init_params)
    record.valid?
    expect_string(record.foo, "foo", "fooalert('xss')")
    expect(record.bar).to eq("")
  end

  it "strips and allow empty always" do
    record = StripAllowEmpty.new(@init_params)
    record.valid?
    record.assign_attributes(@init_params)
    record.valid?
    expect_string(record.foo, "foo", "fooalert('xss')")
    expect(record.bar).to eq("")
  end
end
