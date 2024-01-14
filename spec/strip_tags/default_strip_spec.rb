require "rails_helper"

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
    expect_string(record.foo, "foo> & < ", "foo> & < alert('xss')")
    expect_string(record.bar, "bar", "alert('xss')bar")
    expect_string(record.moo, "moo", "mooalert('xss')")
  end
end
