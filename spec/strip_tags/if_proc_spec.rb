require "rails_helper"

module MockAttributes
  def self.included(base)
    base.attribute :foo
    base.attribute :bar
    base.attribute :strip_me
  end
end

class IfProcMockRecord < Tableless
  include MockAttributes
  strip_tags if: Proc.new { |record| record.strip_me }
end

describe "StripTags: if proc" do
  before(:each) do
    @init_params = {
      foo: "foo<script>alert('xss')</script>",
      bar: "<script>alert('xss')</script>bar"
    }
  end

  it "strips all fields if true (proc)" do
    record = IfProcMockRecord.new(@init_params.merge(strip_me: true))
    record.valid?
    expect_string(record.foo, "foo", "fooalert('xss')")
    expect_string(record.bar, "bar", "alert('xss')bar")
  end

  it "strips no fields if false (proc)" do
    record = IfProcMockRecord.new(@init_params.merge(strip_me: false))
    record.valid?
    expect(record.foo).to eq("foo<script>alert('xss')</script>")
    expect(record.bar).to eq("<script>alert('xss')</script>bar")
  end
end
