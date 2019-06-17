namespace :deploy do

  desc "Build the files"
  task build: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    require 'action_dispatch/routing/inspector'

    puts "\nStarting Build...\n"

    Rake::Task["deploy:start"].invoke
    Rake::Task["deploy:clean"].invoke

    all_routes = Rails.application.routes.routes.map do |route|
      { alias: route.name, path: route.path.spec.to_s, controller: route.defaults[:controller], action: route.defaults[:action] }
    end
    allowed_controllers = ["pages"]
    all_routes.reject! {|route| !allowed_controllers.include?(route[:controller])}

    inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
    all_routes.each do |route|
      puts "Making directory: out/#{branch_name}"
      FileUtils.mkdir_p "out/#{branch_name}" unless File.exists? "out/#{branch_name}"
      FileUtils.chdir "out/#{branch_name}" do
        puts "\nSaving http://localhost:3000#{route[:path]}...\n"
        `wget -mnH -p -k --adjust-extension --timeout=10 --waitretry=10 --tries=15 --retry-connrefused  http://localhost:3000#{route[:path]}`
      end
    end;nil

    Rake::Task["deploy:stop"].invoke
    puts "\nView your files at out/#{branch_name}\n"
  end


  desc 'Start a HTTP server from ./out/ directory'
  task test: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    Dir.chdir 'out' do
      puts "\nStarted HTTP server at http://localhost:8000/#{branch_name}/ Press CTRL+C to exit.\n"
      `python -m SimpleHTTPServer`
    end
  end

  desc 'Stop rails server'
  task stop: :environment do
    File.new("tmp/pids/server.pid").tap { |f| Process.kill 9, f.read.to_i }
    puts "\nRails server stopped\n"
  end

  desc 'Starts rails server'
  task start: :environment do
    puts "\nServer starting...\n"
    `rails s -d`
    puts "\nServer started\n"
  end

  desc "Restart rails server"
  task restart: :environment do
    Rake::Task["deploy:stop"].invoke
    Rake::Task["deploy:start"].invoke
  end


  desc 'Deploy to GitHub Pages'
  task gh_pages: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    puts "\nDeploying to GitHub Pages...\n"
    `cd out`
    `git add --all`
    `git commit -m "Deploy to gh-pages"`
    `git push origin gh-pages`
    `cd ..`
    puts "\nDeployed to: https://tech.powerhrg.com/playgrounds/#{branch_name}\n"
  end


  desc 'Cleanup'
  task clean: :environment do
    puts "\nCleaning directory...\n"
    `rm -rf out`
    FileUtils.mkdir_p "out"
  end


  desc 'Set git worktree'
  task set_worktree: :environment do
    puts "\nSetting git worktree...\n"
    `git worktree add out gh-pages`
  end


  desc 'Prune git worktree'
  task prune_worktree: :environment do
    puts "\nPruning git worktree...\n"
    `git worktree prune`
  end


  # 1. Clean directory
  # 2. Add worktree
  # 3. Build
  # 4. Push
  # 5. Prune worktree

end

desc "Build and deploy your prototype to Playgrounds"
task :deploy => ["deploy:clean", "deploy:set_worktree", "deploy:build", "deploy:gh_pages", "deploy:prune_worktree"]
