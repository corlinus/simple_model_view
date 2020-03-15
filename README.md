# SimpleModelView

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_model_view'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_model_view

## Configuration

  In `config/initializers/simple_model_view.rb` file following options are available

    SimpleModelView.setup do |config|
      # set initial html attributes for collection table
      config.collection_table_html = {}
      config.collection_header_html = {}
      config.collection_wrapper_html = {}

      # set initial html attributes for resource table
      config.resource_table_html = {}
      config.resource_wrapper_html = {}
      config.resource_label_html = {}
      config.resource_value_html = {}

      # set formatter class
      config.formatter = SimpleModelView::ValueFormatter
    end

## Usage

SimpleModelView provides you two main helpers

### resource_table_for

Renders model attributes table using simple helpers.

    <%= resource_table_for @user do |t| %>
      <%= t.row :id %>
      <%= t.row :name %>
    <% end %>

### collection_table_for

    <%= collection_table_for @users do |t| %>
      <%= t.column :id %>
      <%= t.column :name %>
    <% end %>

#### Common options for `row` and `column`

* `title` sets attribute title for table. `human_attribute_name` of String#humanize will be used if `title` is not set.

    `<%= t.row :name, title: 'Article name' %>`

* renders friends array as unorderd list

    `<%= t.row :friends %>`

* `collection: false` option will render attribute as is

    `<%= t.row :roles, collection: false %>`

* `type_specific_class` option will add some useful classes to the wrapper
  * for `numeric` types these are `negative`, `zero`, `positive`
  * for `date` and `datetime` these are `past`, `yesterday`, `today`, `tomorrow`, `future`
  * for `boolean` - `true` and `false`

    `<%= t.row :account, type_specific_class: true %>`

* `custom_class` option will add `child` or `adult` class to the wrapper depends on block result

    `<%= t.row :age, custom_class: {child: { |x| x < 21 }, adult: { |x| x >= 21 } %>`

* `wrapper_html` is a hash of html attributes to be added to wrapper

    `<%= t.row, wrapper_html: {data: {id: t.object.id}} %>`

* `format` will be added to the formatter

  `string` will be used as format itself

    `<%= t.row :price, format: '%.2f' %>`

  `symbol` will be used to find in the locale file

    `<%= t.row :price, format: '%.2f' %>`

* `no_blank_block` if `true` it will render blank span instead of block for `nil` value

### Options for `row`

* `label_html` is a hash of html attributes to be added to label (th tag)
* `value_html` is a hash of html attributes to be added to value (tr tag)

### Options for `column`

* `header_html` is a hash of html attributes to be added to table header (th tag)

### Value types

    id
    string
    integer
    float
    boolean
    date
    time
    inspect # calls inspect
    object # synonym for string for now
    html

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/corlinus/simple_model_view. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the SimpleModelView project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/corlinus/simple_model_view/blob/master/CODE_OF_CONDUCT.md).
