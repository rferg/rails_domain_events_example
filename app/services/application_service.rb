# frozen_string_literal: true

class ApplicationService
  def self.call(*args, **kwargs)
    new(*args, **kwargs).call
  end

  def initialize(*_args, **_kwargs); end
end
