namespace :deploy do

  desc "Build the files"
  task build: :environment do
    puts "Starting Build"
    Rake::Task["deploy:start"].invoke
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    sh 'rm -rf out'
    require 'action_dispatch/routing/inspector'
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
        puts "Saving: http://localhost:3000#{route[:path]}"
        `wget -mnH -p -k --adjust-extension --timeout=10 --waitretry=10 --tries=15 --retry-connrefused  http://localhost:3000#{route[:path]}`
      end
    end;nil

    Rake::Task["deploy:stop"].invoke
    puts "View your files at out/#{branch_name}"
  end


  desc 'Start a HTTP server from ./out/ directory'
  task test: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    Dir.chdir 'out' do
      puts "Started HTTP server at http://localhost:8000/#{branch_name}/ Press CTRL+C to exit."
      `python -m SimpleHTTPServer`
    end
  end

  desc 'Stop rails server'
  task stop: :environment do
    File.new("tmp/pids/server.pid").tap { |f| Process.kill 9, f.read.to_i }
    puts "Rails server Stopped"
  end

  desc 'Starts rails server'
  task start: :environment do
    puts "Server Starting"
    `rails s -d`
    puts "Server Started"
  end

  desc "Restarts rails server"
  task restart: :environment do
    Rake::Task["deploy:stop"].invoke
    Rake::Task["deploy:start"].invoke
  end


  desc 'Deploy to GitHub Pages'
  task gh_pages: :environment do
    sh 'cd out'
    sh 'git add --all'
    sh 'git commit -m "Deploy to gh-pages"'
    sh 'git push origin gh-pages'
    sh 'cd ..'
  end

  desc 'Deploy to GitHub Pages'
  task gh_pages: :environment do
    sh 'cd out'
    sh 'git add --all'
    sh 'git commit -m "Deploy to gh-pages"'
    sh 'git push origin gh-pages --force'
    sh 'cd ..'
  end

  # prepare for push
  # rm -rf out
  # echo "out/" >> .gitignore
  # git worktree add out gh-pages

end


task :all => ["deploy:build", "deploy:gh_pages"]
