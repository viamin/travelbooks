namespace :tmp do
  namespace :assets do 
    desc "Clears javascripts/cache and stylesheets/cache"
    task :clear => :environment do      
      FileUtils.rm(Dir['public/javascripts/cache/[^.]*'])
      FileUtils.rm(Dir['public/stylesheets/cache/[^.]*'])
    end
  end
  namespace :images do
    desc "Clears temp images in public/images/tmp older than 7 days"
    task :clear => :environment do
      `/usr/bin/find #{RAILS_ROOT}/public/images/tmp -type f -mtime +7 -delete`
    end
  end
end