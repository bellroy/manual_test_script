namespace :test do
  desc "Interactively run through the deployment test script."
  task :manual => [:environment] do
    ManualTestScript.run
  end


  desc "Interactively run through the post-deployment test script."
  task :post_deploy => [:environment] do
    ManualTestScript.run(:tags => 'post-deploy')
  end

end
