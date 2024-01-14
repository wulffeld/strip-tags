require "rails_helper"

class CoexistWithOtherValidations < Tableless
  attribute :number, type: Integer

  strip_tags

  validates :number, {
    numericality: { only_integer: true,  greater_than_or_equal_to: 1000 },
    allow_blank: true
  }
end

describe "StripTags: other validations" do
  before(:each) do
    @init_params = {
      foo:  "foo<script>alert('xss')</script>",
      bar:  "<script>alert('xss')</script>bar",
      baz:  "",
      bang: " ",
      foz:  " foz  foz",
      fiz:  "fiz \n  fiz",
      qax:  "\n\t ",
      qux:  "\u200B"
    }
  end

  it "coexists with other validations" do
    record = CoexistWithOtherValidations.new
    record.number = 1000.1
    expect(record.valid?).to be false
    expect(record.errors.include?(:number)).to be true

    record = CoexistWithOtherValidations.new(number: " 1000.2 ")
    expect(record.valid?).to be false
    expect(record.errors.include?(:number)).to be true
  end
end
