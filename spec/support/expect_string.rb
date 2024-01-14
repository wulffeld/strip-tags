def expect_string(field, value_70, value_71_plus)
  if Gem::Version.new(Rails.version) >= Gem::Version.new("7.1")
    expect(field).to eq(value_71_plus)
  else
    expect(field).to eq(value_70)
  end
end
