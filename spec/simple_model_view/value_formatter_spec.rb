# frozen_string_literal: true

RSpec.describe SimpleModelView::ValueFormatter do
  let(:formatter) { described_class.new }

  describe 'formatter.call' do
    it 'value is string' do
      expect(formatter.call('name', :string, nil)).to eq('name')
    end

    it 'true => Yes' do
      expect(formatter.call(true, :boolean, nil)).to eq('Yes')
    end

    it 'symbol format' do
      expect(formatter.call(Time.new(2001, 10, 10, 0, 0, 0, '+03:00'), :date, format: :long)).
        to eq('October 10, 2001 00:00')
    end

    it 'string format "%m/%d/%Y"' do
      expect(formatter.call(Time.new(2014, 9, 10, 0, 0, 0, '+03:00'), :date, format: '%m/%d/%Y')).
        to eq('09/10/2014')
    end

    it 'format Time ' do
      expect(formatter.call(Time.new(2001, 11, 10, 0, 0, 0, '+03:00'), :date, {})).
        to eq('Sat, 10 Nov 2001 00:00:00 +0300')
    end

    it 'format "%.3f"' do
      expect(formatter.call(2.5555, :float, format: '%.3f')).to eq('2.556')
    end

    it 'when format symbol' do
      expect(formatter.call(0.9999, :float, format: :price)).to eq('1.00')
    end
  end
end
