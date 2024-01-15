require "rails_helper"

describe User, type: :model do
  describe "validations" do
    it "strips tags from the name" do
      user = User.new(name: "<script>alert('xss')</script>bar")
      user.valid?
      expect_string(user.name, "bar", "alert('xss')bar")
    end
  end
end
