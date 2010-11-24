require 'bundler/capistrano'
require 'rvm/capistrano'

set :application, "fallow"
set :repository,  "git@github.com:nerdEd/FallowFollow.git"

set :deploy_via, :copy
set :scm, :git

set(:exclude_paths, ["README", "doc", "test", ".rvmrc"])
set :user, "deploy"
set :target_os, :ubuntu

task :production do
  server "173.255.235.76", :app, :web, :db, :primary => true
  set :rails_env, "production"
  set :deploy_to, "/var/vhosts/fallow"
  set :use_sudo, false
end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :custom do
  task :symlink, :roles => :app do
    # always use shared database.yml
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :remove_config_ru, :roles => :app do
    run "rm -f #{release_path}/config.ru"
  end
end

after "deploy:symlink", "custom:symlink"
