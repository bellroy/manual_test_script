require 'rails/railtie'

module ManualTestScript
  class ManualTestScriptRailtie < Rails::Railtie
    rake_tasks do
      load 'tasks/manual_test_script_tasks.rake'
    end
  end
end
