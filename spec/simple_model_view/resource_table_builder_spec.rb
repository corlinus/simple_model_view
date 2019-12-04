# frozen_string_literal: true

RSpec.describe SimpleModelView::ResourceTableBuilder, type: :helper do
  describe '#format' do
    let(:test_model) { TestModel.new('Name') }

    subject { described_class.new(helper, test_model) }

    let(:formatter) { double :formatter_instance, call: nil }

    before { allow(SimpleModelView::ValueFormatter).to receive(:new).and_return(formatter) }

    it 'autodects type and calls formatter' do
      subject.format('string', :string, {})
      expect(formatter).to have_received(:call).with('string', :string, {})
    end

    it 'autodects type and calls formatter with options' do
      subject.format('string', :string, foo: :bar)
      expect(formatter).to have_received(:call).with('string', :string, foo: :bar)
    end

    it 'passes given type to formatter' do
      subject.format(123, :integer, {})
      expect(formatter).to have_received(:call).with(123, :integer, {})
    end

    it 'passes given type options to formatter' do
      subject.format(123, :integer, foo: :bar)
      expect(formatter).to have_received(:call).with(123, :integer, foo: :bar)
    end

    it 'does not call formatter for nil value' do
      subject.format(nil, nil, {})
      expect(formatter).not_to have_received(:call)
    end
  end

  describe '#row' do
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

    subject { described_class.new(self, test_object) }

    let(:model_class) { double human_attribute_name: 'Name' }

    before { allow(test_object).to receive(:class).and_return(model_class) }

    it 'renders for id' do
      expect(subject.row(:id)).to eq('<tr class="id"><th>Name</th><td>1</td></tr>')
    end

    it 'renders for string' do
      expect(subject.row(:name)).to eq('<tr class="string"><th>Name</th><td>Some Name</td></tr>')
    end

    it 'renders for collection' do
      expect(subject.row(:collection_val, collection: true)).to eq(
        '<tr class="collection"><th>Name</th><td><ul>'\
        '<li>name</li><li>surename</li><li><span class="empty">empty</span></li><li>1</li>'\
        '</ul></td></tr>')
    end

    it 'renders empty' do
      expect(subject.row(:nil_val)).to eq(
        '<tr class="object"><th>Name</th><td><span class="empty">empty</span></td></tr>')
    end

    it 'renders when `title:` option is given' do
      expect(subject.row(:name, title: 'Имя')).to eq(
        '<tr class="string"><th>Имя</th><td>Some Name</td></tr>')
    end

    it 'when value is an Integer' do
      expect(subject.row(:integer_val)).to eq(
        '<tr class="integer"><th>Name</th><td>100</td></tr>')
    end

    it 'when value is Float' do
      expect(subject.row(:float_val)).to eq(
        '<tr class="float"><th>Name</th><td>1.98765</td></tr>')
    end

    it 'when value is a Float and format with a symbol' do
      expect(subject.row(:float_val, format: :price)).to eq(
        '<tr class="float"><th>Name</th><td>1.99</td></tr>')
    end

    it 'when value is a Float and format with a string' do
      expect(subject.row(:float_val, format: '%.4f')).to eq(
        '<tr class="float"><th>Name</th><td>1.9876</td></tr>')
    end

    it 'when value is "true" and format with :boolean' do
      expect(subject.row(:none, format: :boolean)).to eq(
        '<tr class="boolean"><th>Name</th><td>Yes</td></tr>')
    end

    it 'when value is a Time and format with a symbol' do
      expect(subject.row(:created_at, format: :long)).to eq(
        '<tr class="time"><th>Name</th><td>October 11, 2014 00:00</td></tr>')
    end

    it 'when value is a Boolean and `as: string` passed' do
      expect(subject.row(:none, as: :string)).to eq(
        '<tr class="string"><th>Name</th><td>true</td></tr>')
    end

    it 'when value is a Time with fromat' do
      expect(
        subject.row(
          :created_at,
          format: :date_month_year_concise,
        )
      ).to eq('<tr class="time"><th>Name</th><td>11-10-14</td></tr>')
    end

    it 'when give varior class and options for label and vlue' do
      expect(subject.row(:name,
          wrapper_html: {class: 'foo'},
          label_html: {align: 'foo'},
          value_html: {bgcolor: 'red'}
        )
      ).to eq('<tr class="foo string"><th align="foo">Name</th><td bgcolor="red">Some Name</td></tr>')
    end

    it 'when type_specific_class is on, value is a float and classes in array' do
      expect(
        subject.row(
          :float_val,
          type_specific_class: true,
          wrapper_html: {class: %w[foo bar]}
        )
      ).to eq('<tr class="foo bar float positive"><th>Name</th><td>1.98765</td></tr>')
    end

    it 'when type_specific_class on and date in past' do
      expect(subject.row(:date_past, type_specific_class: true)).to include(
        'date past yesterday')
    end

    it 'when type_specific_class on, date is future' do
      expect(subject.row(:date_future, type_specific_class: true)).to include('date future')
    end

    it 'when type_specific_class on, date today' do
      expect(subject.row(:date_today, type_specific_class: true)).to include('date today')
    end

    it 'when type_specific_class on add value in custom_class is a proc' do
      expect(
        subject.row(:float_val,
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
        subject.row(
          :float_val,
          custom_class: {
            positive: :positive?,
            negative: :negative?,
          }
        )
      ).to include('float positive')
    end

    it 'when type_specific_class on add custom class, value is nil' do
      expect(
        subject.row(
          :nil_val,
          type_specific_class: true,
          custom_class: {
            negative: proc { |x| x < 100 },
          }
        )
      ).to include('object')
    end

    it 'when not ActiveRecord object is passed' do
      expect(
        described_class.new(self, double(:obj, attr: 'value')).row(:attr)
      ).to eq('<tr class="string"><th>Attr</th><td>value</td></tr>')
    end

    it 'yields block and passes attr value' do
      expect { |b| subject.row(:name, &b) }.to yield_successive_args(test_object.name)
    end

    it 'renders block' do
      expect(subject.row(:name) { |x| helper.content_tag(:i, x) }).
        to eq("<tr class=\"string\"><th>Name</th><td><i>#{test_object.name}</i></td></tr>")
    end

    it 'renders block for collection' do
      expect(subject.row(:collection_val) { |x| helper.content_tag(:i, x) }).
        to eq('<tr class="collection"><th>Name</th><td><ul><li><i>name</i></li><li><i>surename</i>'\
          '</li><li><i></i></li><li><i>1</i></li></ul></td></tr>')
    end

    it 'yields block for collection if `collection: false` and passes the collection' do
      expect { |b| subject.row(:collection_val, collection: false, &b) }.
        to yield_successive_args(test_object.collection_val)
    end

    it 'yields block once for collection if `collection: false` is passed' do
      expect { |b| subject.row(:collection_val, collection: false, &b) }.
        to yield_control.once
    end

    it 'renders block one time for collection if `collection: false` is passed' do
      expect(subject.row(:collection_val, collection: false) { |x| helper.content_tag(:i, x.inspect) }).
        to eq("<tr class=\"object\"><th>Name</th><td><i>#{
          helper.send :html_escape, test_object.collection_val.inspect
        }</i></td></tr>")
    end

    context 'when call formatter and receive whith normal value' do
      let(:formatter) { double call: nil }

      before { allow(SimpleModelView::ValueFormatter).to receive(:new).and_return(formatter) }

      it 'when autodetect string' do
        subject.row(:name)
        expect(formatter).to have_received(:call).with('Some Name', :string, {})
      end

      it 'when give type' do
        subject.row(:none, as: :boolean)
        expect(formatter).to have_received(:call).with(true, :boolean, as: :boolean)
      end

      it 'when autudetect type and give format' do
        subject.row(:created_at, format: :long)
        expect(formatter).to have_received(:call).
          with(Time.new(2014, 10, 11), :time, format: :long)
      end
    end
  end
end
