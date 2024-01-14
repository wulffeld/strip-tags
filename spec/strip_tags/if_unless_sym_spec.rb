require "rails_helper"

module MockAttributes
  def self.included(base)
    base.attribute :foo
    base.attribute :bar
    base.attribute :strip_me
    base.attribute :skip_me
  end
end

class IfSymMockRecord < Tableless
  include MockAttributes

  strip_tags if: :strip_me?

  def strip_me?
    strip_me
  end
end

class UnlessSymMockRecord < Tableless
  include MockAttributes

  strip_tags unless: :skip_me?

  def skip_me?
    skip_me
  end
end

describe "StripTags: if / unless option" do
  before(:each) do
    @init_params = {
      foo:  "foo<script>alert('xss')</script>",
      bar:  "<script>alert('xss')</script>bar"
    }
  end

  it "strips all fields if true" do
    record = IfSymMockRecord.new(@init_params.merge(strip_me: true))
    record.valid?
    expect_string(record.foo, "foo", "fooalert('xss')")
    expect_string(record.bar, "bar", "alert('xss')bar")
  end

  it "strips no fields if false" do
    record = IfSymMockRecord.new(@init_params.merge(strip_me: false))
    record.valid?
    expect(record.foo).to eq("foo<script>alert('xss')</script>")
    expect(record.bar).to eq("<script>alert('xss')</script>bar")
  end


  it "strips all fields unless false" do
    record = UnlessSymMockRecord.new(@init_params.merge(skip_me: false))
    record.valid?
    expect_string(record.foo, "foo", "fooalert('xss')")
    expect_string(record.bar, "bar", "alert('xss')bar")
  end

  it "strips no fields unless true" do
    record = UnlessSymMockRecord.new(@init_params.merge(skip_me: true))
    record.valid?
    expect(record.foo).to eq("foo<script>alert('xss')</script>")
    expect(record.bar).to eq("<script>alert('xss')</script>bar")
  end
end
