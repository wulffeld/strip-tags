require "spec_helper"

module MockAttributes
  def self.included(base)
    base.attribute :foo
    base.attribute :bar
    base.attribute :moo
  end
end

class StripOnlyOneMockRecord < Tableless
  include MockAttributes
  strip_tags only: :foo
end

class StripOnlyTwoMockRecord < Tableless
  include MockAttributes
  strip_tags only: [:foo, :bar]
end

class StripExceptOneMockRecord < Tableless
  include MockAttributes
  strip_tags except: :foo
end

class StripExceptTwoMockRecord < Tableless
  include MockAttributes
  strip_tags except: [:foo, :bar]
end

describe "StripTags: only / except option" do
  before(:each) do
    @init_params = {
      foo: "foo<script>alert('xss')</script>",
      bar: "<script>alert('xss')</script>bar",
      moo: "moo<script>alert('xss')</script>"
    }
  end

  it "strips only one field" do
    record = StripOnlyOneMockRecord.new(@init_params)
    record.valid?
    expect(record.foo).to eq("foo")
    expect(record.bar).to eq("<script>alert('xss')</script>bar")
    expect(record.moo).to eq("moo<script>alert('xss')</script>")
  end

  it "strips only two fields" do
    record = StripOnlyTwoMockRecord.new(@init_params)
    record.valid?
    expect(record.foo).to eq("foo")
    expect(record.bar).to eq("bar")
    expect(record.moo).to eq("moo<script>alert('xss')</script>")
  end

  it "strips all except one field" do
    record = StripExceptOneMockRecord.new(@init_params)
    record.valid?
    expect(record.foo).to eq("foo<script>alert('xss')</script>")
    expect(record.bar).to eq("bar")
    expect(record.moo).to eq("moo")
  end

  it "strips all except two fields" do
    record = StripExceptTwoMockRecord.new(@init_params)
    record.valid?
    expect(record.foo).to eq("foo<script>alert('xss')</script>")
    expect(record.bar).to eq("<script>alert('xss')</script>bar")
    expect(record.moo).to eq("moo")
  end
end
