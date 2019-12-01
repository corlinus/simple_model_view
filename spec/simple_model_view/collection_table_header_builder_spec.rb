# frozen_string_literal: true

RSpec.describe SimpleModelView::CollectionTableHeaderBuilder, type: :helper do
  describe '#column' do
    let(:collection) { [] }

    subject { described_class.new(helper, collection) }

    it 'renders header' do
      expect(subject.column(:id)).to eq('<th>Id</th>')
    end

    it 'render header with passed title' do
      expect(subject.column(:id, title: 'ID')).to eq('<th>ID</th>')
    end

    it 'renders header with passed header_html attributes' do
      expect(subject.column(:id, header_html: {class: 'th'})).to eq('<th class="th">Id</th>')
    end

    it 'does not yields block' do
      expect { |b| subject.column(:id, &b) }.not_to yield_control
    end
  end

  describe '#actions' do
    let(:collection) { [] }

    subject { described_class.new(helper, collection) }

    it 'renders actions header' do
      expect(subject.actions).to eq('<th></th>')
    end

    it 'renders actions header with title' do
      expect(subject.actions(title: 'Actions')).to eq('<th>Actions</th>')
    end

    it 'renders actions header with passed header_html attributes' do
      expect(subject.actions(header_html: {class: 'th'})).to eq('<th class="th"></th>')
    end

    it 'does not yields block' do
      expect { |b| subject.actions(:id, &b) }.not_to yield_control
    end
  end
end
