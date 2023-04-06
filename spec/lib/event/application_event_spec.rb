# frozen_string_literal: true

module Event
  RSpec.describe ApplicationEvent do
    let(:event) { described_class.new }

    describe '#record_publication' do
      it 'is published for the given stage' do
        stage = Constants::Stages::AFTER_COMMIT
        event.record_publication(stage)
        expect(event.published?(stage)).to be(true)
      end

      it 'is not published for a different stage' do
        event.record_publication(Constants::Stages::AFTER_COMMIT)
        expect(event.published?(Constants::Stages::BEFORE_COMMIT)).to be(false)
      end

      it 'raises if attempts to record for same stage twice' do
        stage = Constants::Stages::AFTER_COMMIT
        event.record_publication(stage)
        expect { event.record_publication(stage) }.to raise_error(/already published/i)
      end
    end

    describe '#published?' do
      it 'is true if stage was recorded' do
        stage = Constants::Stages::AFTER_COMMIT
        event.record_publication(stage)
        expect(event.published?(stage)).to be(true)
      end

      it 'is false if stage was not recorded' do
        expect(event.published?(Constants::Stages::AFTER_COMMIT)).to be(false)
      end
    end

    describe '#unpublished?' do
      it 'is false if stage was recorded' do
        stage = Constants::Stages::AFTER_COMMIT
        event.record_publication(stage)
        expect(event.unpublished?(stage)).to be(false)
      end

      it 'is true if stage was not recorded' do
        expect(event.unpublished?(Constants::Stages::AFTER_COMMIT)).to be(true)
      end
    end
  end
end
