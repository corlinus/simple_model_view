# frozen_string_literal: true

RSpec.describe SimpleModelView::ActionViewHelperBuilder, type: :helper do
  let(:test_object) { Struct.new(:id).new(123) }

  subject { described_class.new(helper) }

  describe '#resource_table' do
    it 'renders html table' do
      expect(
        subject.resource_table(test_object) do |t|
          t.row :id
        end
      ).to eq '<table class="table"><tbody>'\
        '<tr class="id"><th>Id</th><td>123</td></tr>'\
        '</tbody></table>'
    end
  end

  describe '#collection_table' do
    it 'renders html table' do
      expect(
        subject.collection_table([test_object]) do |t|
          t.column :id
        end
      ).to eq '<table class="table">'\
        '<thead><tr><th>Id</th></tr></thead>'\
        '<tbody><tr><td class="id">123</td></tr></tbody>'\
        '</table>'
    end
  end
end
