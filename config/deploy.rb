set :application, "travelbooks"
set :repository,  "svn+ssh://bart@elguapo.homedns.org/home/Documents/subversion/#{application}/trunk"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :deploy_to, "~/#{application}"

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
end

deploy.task :bart, :roles => :web do
  run "echo $PATH"
  run "which svn"

  run "export PATH=$PATH:/usr/local/bin"
  run "echo $PATH"
  run "svn"
end