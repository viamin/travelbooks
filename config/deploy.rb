set :application, "travelbooks"
set :repository,  "svn+ssh://bart@elguapo.dyndns.info/home/Documents/subversion/#{application}/trunk"
set :application_root, "/home/travell0/#{application}/current"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :deploy_to, "/home/travell0/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "66.84.0.135"
role :web, "66.84.0.135"
role :db,  "66.84.0.135", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
 set :user, "travell0"
 set :scm_command, "PATH=$PATH:/usr/local/bin svn"
 set :svn, "/usr/local/bin/svn"
 set :user_sudo, false

# Save some space
 set :keep_releases, 3
 
# =============================================================================
# SSH OPTIONS
# =============================================================================
 ssh_options[:keys] = %w(~/.ssh/id_dsa)
# ssh_options[:port] = 25

# =============================================================================
# TASKS
# =============================================================================
# Define tasks that run on all (or only some) of the machines. You can specify
# a role (or set of roles) that each task should be executed on. You can also
# narrow the set of servers to a subset of a role by specifying options, which
# must match the options given for the servers to select (like :primary => true)

deploy.task :restart, :roles => :web do
    # run "killall -u `whoami` dispatch.fcgi"
    run "touch #{application_root}/tmp/restart.txt"
    run "killall -u `whoami` ar_sendmail"
end

desc "Displays simple diagnostic information about the server"
deploy.task :bart, :roles => :app do
  run "echo $PATH"
  run "which svn"

  run "export PATH=$PATH:/usr/local/bin"
  run "echo $PATH"
  run "svn"
end

deploy.task :before_deploy, :roles => :app do
  run "echo 'Did you edit the authorized_keys file on elguapo before trying to deploy?'"
end

desc "Fixes symlinks and environment for production mode"
deploy.task :after_deploy, :roles => :app do
  run "/bin/mkdir -p #{deploy_to}/shared/tmp_images"
  run "/bin/mkdir -p #{deploy_to}/shared/user_images"
  run "/bin/mkdir -p #{deploy_to}/shared/book_images"
  run "/bin/ln -s #{deploy_to}/shared/tmp_images #{deploy_to}/current/public/images/tmp"
  run "/bin/ln -s #{deploy_to}/shared/user_images #{deploy_to}/current/public/images/users"
  run "/bin/ln -s #{deploy_to}/shared/book_images #{deploy_to}/current/public/images/books"
  fix_perms
#  run "/bin/mv #{deploy_to}/current/config/environment.rb.server #{deploy_to}/current/config/environment.rb"
  run "echo \"ENV['RAILS_ENV'] ||= 'production'\" > #{deploy_to}/current/config/environment.rb.online"
  run "cat #{deploy_to}/current/config/environment.rb >> #{deploy_to}/current/config/environment.rb.online"
#  run "(echo ',s/rmagick/RMagick/'; echo 'wq') | ed -s #{deploy_to}/current/config/environment.rb.online"
  run "/bin/mv #{deploy_to}/current/config/environment.rb.online #{deploy_to}/current/config/environment.rb"
#  Rake::Task["gems:install"]
#  Rake::Task["gems:unpack"]
#  Rake::Task["gems:build"]
#  Rake::Task["gems:unpack:dependencies"]
#  Rake::Task["gems:refresh_specs"]
#  Rake::Task["gems"]
  fix_others
  restart
#  use_ar_mailer
end

desc "Sets all file perms (except dispatch.*) to 644 and all directory perms to 755"
deploy.task :fix_perms, :roles => :app do
  run "/usr/bin/find #{deploy_to}/current/ -type f | /usr/bin/xargs /bin/chmod 644"
  run "/usr/bin/find #{deploy_to}/current/ -type d | /usr/bin/xargs /bin/chmod 755"
  run "/bin/chmod 755 #{deploy_to}/current/public/dispatch.*"
  run "/bin/chmod 777 #{deploy_to}/shared/tmp_images"
end
  
desc "Fixes symlinks for other deployed sites under this one"
deploy.task :fix_others, :roles => :app do
  run "ln -s /home/#{user}/bartandkat.com/current/public/ #{deploy_to}/current/public/bartandkat.com"
end
  
desc "Replace ActionMailer::Base with ActionMailer::ARMailer in Exception Notifier"
deploy.task :use_ar_mailer, :roles => :app do
#  run "sed -i .bak -E s/ActionMailer::Base/ActionMailer::ARMailer/g vendor/plugins/exception_notification/lib/exception_notifier.rb"
  run "ar_sendmail --max-age 0 -d -c #{application_root} -e production"
end

desc "Comment out the DummyClass stuff from InlineAttachment gem"
deploy.task :fix_inline_attachment, :roles => :app do
  run "sed '104i\
  =begin' < #{application_root}/vendor/lib/InlineAttachment-*/lib/inline_attachment.rb > #{application_root}/vendor/lib/InlineAttachment-*/lib/inline_attachment.rb"
  run "sed '$a\
  =end
  ' < #{application_root}/vendor/lib/InlineAttachment-*/lib/inline_attachment.rb > #{application_root}/vendor/lib/InlineAttachment-*/lib/inline_attachment.rb"
end

# Tossing this in the mix so that migrations happen immediately after
# the code has been deployed 
after "deploy:update", "deploy:migrate"
