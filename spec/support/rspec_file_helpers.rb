# frozen_string_literal: true

module RspecFileHelpers

  def fixture_file(name)
    if self.class.respond_to?(:fixture_path)
      default = File.join(self.class.fixture_path, name)
      return default if File.exist?(default)
    end

    File.join(Rails.root, 'spec', 'fixtures', 'files', name)
  end

end
