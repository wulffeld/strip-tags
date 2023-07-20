# strip_tags

[![Gem Version](http://img.shields.io/gem/v/strip-tags.svg)](https://rubygems.org/gems/strip-tags)
[![Build Status](https://github.com/wulffeld/strip-tags/workflows/CI/badge.svg?branch=main)](https://github.com/wulffeld/strip-tags/actions?query=workflow%3ACI)
[![Gem Downloads](https://img.shields.io/gem/dt/strip-tags.svg)](https://rubygems.org/gems/strip-tags)
[![Maintainability](https://api.codeclimate.com/v1/badges/7b3c646f87ca2d6d691c/maintainability)](https://codeclimate.com/github/wulffeld/strip-tags)

An ActiveModel extension that strips tags from attributes before validation using the strip_tags helper.

It preserves '&', '<' and '>' characters.

It works by adding a before_validation hook to the record.  By default, all
attributes are stripped of whitespace, but `:only` and `:except`
options can be used to limit which attributes are stripped.  Both options accept
a single attribute (`only: :field`) or arrays of attributes (`except: [:field1, :field2, :field3]`).

It's also possible to skip stripping the attributes altogether per model using the `:if` and `:unless` options.

## Installation

Include the gem in your Gemfile:

```ruby
gem "strip-tags"
```

## Examples

### Default Behavior

```ruby
class DrunkPokerPlayer < ActiveRecord::Base
  strip_tags
end
```

### Using `except`

```ruby
# all attributes will be stripped except :boxers
class SoberPokerPlayer < ActiveRecord::Base
  strip_tags except: :boxers
end
```

### Using `only`

```ruby
# only :shoe, :sock, and :glove attributes will be stripped
class ConservativePokerPlayer < ActiveRecord::Base
  strip_tags only: [:shoe, :sock, :glove]
end
```

### Using `if`

```ruby
# Only records with odd ids will be stripped
class OddPokerPlayer < ActiveRecord::Base
  strip_tags if: :strip_me?

  def strip_me?
    id.odd?
  end
end
```

### Using `unless`

```ruby
# strip_tags will be applied randomly
class RandomPokerPlayer < ActiveRecord::Base
  strip_tags unless: :strip_me?

  def strip_me?
    [true, false].sample
  end
end
```

### Using `allow_empty`

```ruby
# Empty attributes will not be converted to nil
class BrokePokerPlayer < ActiveRecord::Base
  strip_tags allow_empty: true
end
```

## Usage Patterns

### Other ORMs implementing `ActiveModel`

It also works on other ActiveModel classes, such as [Mongoid](http://mongoid.org/) documents:

```ruby
class User
  include Mongoid::Document

  strip_tags only: :email
end
```

### Using it with [`ActiveAttr`](https://github.com/cgriego/active_attr)

```ruby
class Person
  include ActiveAttr::Model
  include ActiveModel::Validations::Callbacks

  attribute :name
  attribute :email

  strip_tags
end

```

### Using it directly

```ruby
# where record is an ActiveModel instance
StripTags.strip(record,: true)

# works directly on Strings too
StripTags.strip(" foo \t") #=> "foo"
StripTags.strip(" foo   bar",: true) #=> "foo bar"
```

## Testing

StripTags provides an RSpec/Shoulda-compatible matcher for easier
testing of attribute assignment. You can use this with
[RSpec](http://rspec.info/), [Shoulda](https://github.com/thoughtbot/shoulda),
[Minitest-MatchersVaccine](https://github.com/rmm5t/minitest-matchers_vaccine)
(preferred), or
[Minitest-Matchers](https://github.com/wojtekmach/minitest-matchers).

### Setup `spec_helper.rb` or `test_helper.rb`

#### To initialize **RSpec**, add this to your `spec_helper.rb`:

```ruby
require "strip-tags/matchers"

RSpec.configure do |config|
  config.include StripTags::Matchers
end
```

#### To initialize **Shoulda (with test-unit)**, add this to your `test_helper.rb`:

```ruby
require "strip-tags/matchers"

class Test::Unit::TestCase
  extend StripTags::Matchers
end
```

OR if in a Rails environment, you might prefer this:

``` ruby
require "strip-tags/matchers"

class ActiveSupport::TestCase
  extend StripTags::Matchers
end
```

#### To initialize **Minitest-MatchersVaccine**, add this to your `test_helper.rb`:

```ruby
require "strip-tags/matchers"

class MiniTest::Spec
  include StripTags::Matchers
end
```

OR if in a Rails environment, you might prefer this:

``` ruby
require "strip-tags/matchers"

class ActiveSupport::TestCase
  include StripTags::Matchers
end
```

#### To initialize **Minitest-Matchers**, add this to your `test_helper.rb`:

```ruby
require "strip-tags/matchers"

class MiniTest::Spec
  include StripTags::Matchers
end
```

### Writing Tests

**RSpec**:

```ruby
describe User do
  it { is_expected.to strip_tag(:name) }
  it { is_expected.not_to strip_tag(:password)  }
end
```

**Shoulda (with test-unit)**:

```ruby
class UserTest < ActiveSupport::TestCase
  should strip_tag(:name)
  should strip_tags(:name, :email)
  should_not strip_tag(:password)
  should_not strip_tags(:password, :encrypted_password)
end
```

**Minitest-MatchersVaccine**:

```ruby
describe User do
  subject { User.new }

  it "strips attributes" do
    must strip_tag(:name)
    must strip_tags(:name, :email)
    wont strip_tag(:password)
    wont strip_tags(:password, :encrypted_password)
  end
end
```

**Minitest-Matchers**:

```ruby
describe User do
  subject { User.new }

  must { strip_tag(:name) }
  must { strip_tags(:name, :email) }
  wont { strip_tag(:password) }
  wont { strip_tags(:password, :encrypted_password) }
end
```

## Support

Submit suggestions or feature requests as a GitHub Issue or Pull
Request (preferred). If you send a pull request, remember to update the
corresponding unit tests.  In fact, I prefer new features to be submitted in the
form of new unit tests.

## Credits

Original code 99% from the [strip_attributes](https://github.com/rmm5t/strip_attributes) gem.

## Versioning

Semantic Versioning 2.0 as defined at <http://semver.org>.
