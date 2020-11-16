# Just setup PATHS so we can access project files
#
# All individual CLIs are defined in separate thor files under lib/tasks
#
require 'thor'

$LOAD_PATH.push File.expand_path('lib')

require 'tasks/common/task_common'

base = File.join(File.expand_path('lib'), 'tasks')

Dir["#{base}/**/*.thor"].each do |f|
  next unless File.file?(f)

  Thor::Util.load_thorfile(f)
end
