# frozen_string_literal: true

RSpec.describe SimpleModelView::TemplateHelpers do
  let(:class_fabric) do
    ->(method_name) do
      Class.new do
        include SimpleModelView::TemplateHelpers

        method_name
      end.new
    end
  end

  describe '#merge_html_attrs' do
    subject { class_fabric.call(:merge_html_attrs) }

    it 'merge data in html params' do
      expect(subject.merge_html_attrs({data: {a: '1', b: '2'}}, data: {a: '2', c: '4'})).to eq(data: {a: '2', b: '2', c: '4'})
    end

    it { expect(subject.merge_html_attrs({data: {a: '1', b: '2'}}, {})).to eq(data: {a: '1', b: '2'}) }

    it { expect(subject.merge_html_attrs({data: {a: '1', b: '2'}}, data: nil)).to eq({}) }

    it { expect(subject.merge_html_attrs({class: :color}, class: :color)).to eq(class: %i[color color]) }

    it { expect(subject.merge_html_attrs({class: :color}, class: nil)).to eq({}) }

    it { expect(subject.merge_html_attrs({class: 'blue'}, class: %i[red integer])).to eq(class: ['blue', :red, :integer]) }

    it 'merge data, class and as options' do
      expect(subject.merge_html_attrs({class: 'blue', data: {a: 1, b: 2}},
        class: %i[blue integer], data: {b: 3, c: 4}, as: :integer)).to eq(
          class: ['blue', :blue, :integer], data: {a: 1, b: 3, c: 4}, as: :integer
        )
    end
  end
end
