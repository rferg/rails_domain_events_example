# frozen_string_literal: true

require 'rails_helper'

class EventAddingEvent < Event::ApplicationEvent
  def initialize(model, event_to_add)
    @model = model
    @event_to_add = event_to_add
    super()
  end

  def record_publication(stage)
    super
    @model.add_event(@event_to_add)
  end
end

RSpec.shared_examples 'event_emitter' do
  def assert_published(event, stage)
    expect(event.published?(stage)).to be(true)
  end

  describe 'after_save' do
    let(:model) { build(described_class.model_name.param_key.to_sym) }
    let(:stage) { Event::Constants::Stages::BEFORE_COMMIT }

    it 'completes successfully if no events' do
      expect { model.save }.to change(described_class, :count).by(1)
    end

    it 'publishes a single event' do
      event = Event::ApplicationEvent.new
      model.add_event(event)
      model.save
      assert_published(event, stage)
    end

    it 'publishes multiple events' do
      events = 3.times.map { Event::ApplicationEvent.new }
      events.each { |evt| model.add_event(evt) }
      model.save
      events.each { |evt| assert_published(evt, stage) }
    end

    it 'publishes events added during publication process' do
      added_event = Event::ApplicationEvent.new
      adding_event = EventAddingEvent.new(model, added_event)
      model.add_event(adding_event)
      model.save
      assert_published(added_event, stage)
    end
  end

  describe 'after_destroy' do
    let(:model) { create(described_class.model_name.param_key.to_sym) }
    let(:stage) { Event::Constants::Stages::BEFORE_COMMIT }

    it 'completes successfully if no events' do
      model.destroy
      expect(model.destroyed?).to be(true)
    end

    it 'publishes a single event' do
      event = Event::ApplicationEvent.new
      model.add_event(event)
      model.destroy
      assert_published(event, stage)
    end

    it 'publishes multiple events' do
      events = 3.times.map { Event::ApplicationEvent.new }
      events.each { |evt| model.add_event(evt) }
      model.destroy
      events.each { |evt| assert_published(evt, stage) }
    end

    it 'publishes events added during publication process' do
      added_event = Event::ApplicationEvent.new
      adding_event = EventAddingEvent.new(model, added_event)
      model.add_event(adding_event)
      model.destroy
      assert_published(added_event, stage)
    end
  end

  describe 'after_commit' do
    let(:model) { build(described_class.model_name.param_key.to_sym) }
    let(:stage) { Event::Constants::Stages::AFTER_COMMIT }

    it 'completes successfully if no events' do
      expect { model.save }.to change(described_class, :count).by(1)
    end

    it 'publishes a single event' do
      event = Event::ApplicationEvent.new
      model.add_event(event)
      model.save
      assert_published(event, stage)
    end

    it 'publishes multiple events' do
      events = 3.times.map { Event::ApplicationEvent.new }
      events.each { |evt| model.add_event(evt) }
      model.save
      events.each { |evt| assert_published(evt, stage) }
    end

    it 'publishes events added during publication process' do
      added_event = Event::ApplicationEvent.new
      adding_event = EventAddingEvent.new(model, added_event)
      model.add_event(adding_event)
      model.save
      assert_published(added_event, stage)
    end
  end
end
