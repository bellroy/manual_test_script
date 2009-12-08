namespace :test do
  desc "Interactively run through the deployment test script."
  task :manual => [:environment] do
    ManualTestScript.run
  end
end
