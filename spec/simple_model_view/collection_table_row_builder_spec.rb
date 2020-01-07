# frozen_string_literal: true

RSpec.describe SimpleModelView::CollectionTableRowBuilder, type: :helper do
  describe '#column' do
    let(:test_object) do
      TestObject.new(
        'Name',
        'Some Name',
        1,
        {a: :a},
        100,
        1.98765,
        false,
        true,
        Time.new(2014, 10, 11),
        ['name', 'surename', nil, 1],
        nil,
        Date.today - 1,
        Date.new(2119, 7, 4),
        Date.today,
        Time.now
      )
    end

    subject { described_class.new(helper, test_object) }

    it 'renders an id' do
      expect(subject.column(:id)).to eq('<td class="id">1</td>')
    end

    it 'renders a string' do
      expect(subject.column(:name)).to eq('<td class="string">Some Name</td>')
    end

    it 'renders a collection' do
      expect(subject.column(:collection_val)).to eq(
        '<td class="collection"><ul>'\
        '<li>name</li><li>surename</li><li><span class="empty">empty</span></li><li>1</li>'\
        '</ul></td>')
    end

    it 'renders empty value' do
      expect(subject.column(:nil_val)).to eq(
        '<td class="object"><span class="empty">empty</span></td>')
    end

    it 'renders an Integer value' do
      expect(subject.column(:integer_val)).to eq(
        '<td class="integer">100</td>')
    end

    it 'when value is a Float' do
      expect(subject.column(:float_val)).to eq(
        '<td class="float">1.98765</td>')
    end

    it 'renders with html attrbiutes passed' do
      expect(subject.column(:name, wrapper_html: {class: 'foo'})).
        to eq('<td class="foo string">Some Name</td>')
    end

    it 'renders with html attrbiutes passed with class as an array' do
      expect(
        subject.column(
          :float_val,
          wrapper_html: {class: %w[foo bar]}
        )
      ).to eq('<td class="foo bar float">1.98765</td>')
    end

    it 'renders with `type_specific_class` is on' do
      expect(
        subject.column(
          :float_val,
          type_specific_class: true
        )
      ).to eq('<td class="float positive">1.98765</td>')
    end

    it 'when type_specific_class on add value in custom_class is a proc' do
      expect(
        subject.column(:float_val,
          type_specific_class: true,
          custom_class: {
            below_100: proc { |x| x < 100 },
            above_100: proc { |x| x > 100 },
          }
        )
      ).to include('float positive below_100')
    end

    it 'when type_specific_class on and value in custom_class is a Symbol' do
      expect(
        subject.column(
          :float_val,
          custom_class: {
            positive: :positive?,
            negative: :negative?,
          }
        )
      ).to include('float positive')
    end

    it 'yields block and passes attr value' do
      expect { |b| subject.column(:name, &b) }.to yield_successive_args(test_object.name)
    end

    it 'renders block' do
      expect(subject.column(:name) { |x| helper.content_tag(:i, x) }).
        to eq("<td class=\"string\"><i>#{test_object.name}</i></td>")
    end

    it 'renders block for nil value' do
      expect(subject.column(:nil_val) { |x| helper.content_tag(:i, x) }).
        to eq('<td class="object"><i></i></td>')
    end

    it 'does not render block with no_blank_block for nil value' do
      expect(subject.column(:nil_val, no_blank_block: true) { |x| helper.content_tag(:i, x) }).
        to eq('<td class="object"><span class="empty">empty</span></td>')
    end

    it 'renders block for collection' do
      expect(subject.column(:collection_val) { |x| helper.content_tag(:i, x) }).
        to eq('<td class="collection"><ul><li><i>name</i></li><li><i>surename</i>'\
          '</li><li><i></i></li><li><i>1</i></li></ul></td>')
    end

    it 'yields block for collection if `collection: false` is passed and passes collection' do
      expect { |b| subject.column(:collection_val, collection: false, &b) }.
        to yield_successive_args(test_object.collection_val)
    end

    it 'yields block one time for collection if `collection: false` is passed' do
      expect { |b| subject.column(:collection_val, collection: false, &b) }.
        to yield_control.once
    end

    it 'renders block one time for collection if `collection: false` is passed' do
      expect(subject.column(:collection_val, collection: false) { |x| helper.content_tag(:i, x.inspect) }).
        to eq("<td class=\"object\"><i>#{
          helper.send :html_escape, test_object.collection_val.inspect
        }</i></td>")
    end
  end

  describe '#actions' do
    let(:test_object) { Object.new }
    subject { described_class.new(helper, test_object) }

    it 'renders actions cell' do
      expect(subject.actions).to eq('<td></td>')
    end

    it 'renders actions cell with title' do
      expect(subject.actions(title: 'Actions')).to eq('<td></td>')
    end

    it 'renders actions cell with passed header_html attributes' do
      expect(subject.actions(header_html: {class: 'th'})).to eq('<td></td>')
    end

    it 'yeilds once if block given' do
      expect { |b| subject.actions(header_html: {class: 'th'}, &b) }.to yield_control.once
    end

    it 'passes object to block if block given' do
      expect { |b| subject.actions(header_html: {class: 'th'}, &b) }.
        to yield_with_args(test_object)
    end
  end
end
