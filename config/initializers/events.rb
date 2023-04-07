# frozen_string_literal: true

unless Rails.application.config.eager_load
  load_paths = Dir['app/models/**/events/**/*.rb'].map { |f| "#{Dir.pwd}/#{f}" }
  Rails.application.config.to_prepare do
    load_paths.each { |p| require_dependency(p) }
  end
  ActiveSupport::Reloader.to_prepare do
    load_paths.each { |p| require_dependency(p) }
  end
end
