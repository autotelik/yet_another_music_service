# frozen_string_literal: true

module RspecFileHelpers

  def fixture_file(name)
    return File.join(self.class.fixture_path, name) if self.class.respond_to?(:fixture_path) && self.class.fixture_path

    File.join(Rails.root, 'spec', 'fixtures', 'files', name)
  end

end
