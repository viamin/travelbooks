set :application, "travelbooks"
set :repository,  "svn+ssh://bart@elguapo.homedns.org/home/Documents/subversion/#{application}/trunk"
set :application_root, "/home/travell0/#{application}/current/."

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :deploy_to, "/home/travell0/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "75.126.168.192"
role :web, "75.126.168.192"
role :db,  "75.126.168.192", :primary => true

# =============================================================================
# OPTIONAL VARIABLES
# =============================================================================
 set :user, "travell0"
 set :scm_command, "PATH=$PATH:/usr/local/bin svn"
 set :svn, "/usr/local/bin/svn"

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
    run "killall -u `whoami` dispatch.fcgi"
    run "killall -u `whoami` ar_sendmail"
end

desc "Displays simple diagnostic information about the server"
deploy.task :bart, :roles => :web do
  run "echo $PATH"
  run "which svn"

  run "export PATH=$PATH:/usr/local/bin"
  run "echo $PATH"
  run "svn"
end

desc "Fixes symlinks and environment for production mode"
deploy.task :after_deploy, :roles => :web do
  run "/bin/mkdir -p #{deploy_to}/shared/tmp_images"
  run "/bin/mkdir -p #{deploy_to}/shared/user_images"
  run "/bin/mkdir -p #{deploy_to}/shared/book_images"
  run "/bin/ln -s #{deploy_to}/shared/tmp_images #{deploy_to}/current/public/images/tmp"
  run "/bin/ln -s #{deploy_to}/shared/user_images #{deploy_to}/current/public/images/users"
  run "/bin/ln -s #{deploy_to}/shared/book_images #{deploy_to}/current/public/images/books"
  fix_perms
  run "/bin/mv #{deploy_to}/current/config/environment.rb.server #{deploy_to}/current/config/environment.rb"
  fix_others
  restart
#  use_ar_mailer
end

desc "Sets all file perms (except dispatch.*) to 644 and all directory perms to 755"
deploy.task :fix_perms, :roles => :web do
  run "/usr/bin/find #{deploy_to}/current/ -type f | /usr/bin/xargs /bin/chmod 644"
  run "/usr/bin/find #{deploy_to}/current/ -type d | /usr/bin/xargs /bin/chmod 755"
  run "/bin/chmod 755 #{deploy_to}/current/public/dispatch.*"
  run "/bin/chmod 777 #{deploy_to}/shared/tmp_images"
end
  
desc "Fixes symlinks for other deployed sites under this one"
deploy.task :fix_others, :roles => :web do
  run "ln -s /home/#{user}/bartandkat.com/current/public/ #{deploy_to}/current/public/bartandkat.com"
end
  
desc "Replace ActionMailer::Base with ActionMailer::ARMailer in Exception Notifier"
deploy.task :use_ar_mailer, :roles => :web do
#  run "sed -i .bak -E s/ActionMailer::Base/ActionMailer::ARMailer/g vendor/plugins/exception_notification/lib/exception_notifier.rb"
  run "ar_sendmail --max-age 0 -d -c #{application_root} -e production"
end
