# frozen_string_literal: true

require 'action_dispatch/routing/inspector'
require 'fileutils'

namespace :deploy do # rubocop:disable Metrics/BlockLength
  desc 'Build the files'
  task build: :environment do # rubocop:disable Metrics/BlockLength
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    out = "out/#{branch_name}"

    puts "\n"
    puts 'Starting Build...'
    puts "\n"

    ['deploy:yarn', 'deploy:start'].each { |task| Rake::Task[task].invoke }

    all_routes = Rails.application.routes.routes.map do |route|
      {
        alias: route.name,
        path: route.path.spec.to_s,
        controller: route.defaults[:controller],
        action: route.defaults[:action]
      }
    end

    allowed_controllers = ['pages']
    all_routes.select! { |route| allowed_controllers.include?(route[:controller]) }
    ActionDispatch::Routing::RoutesInspector.new(all_routes)

    all_routes.each do |route|
      route_path = route[:path].gsub(/\(.:format\)/, '')

      puts "\n"
      puts "Making directory: #{out}"
      puts "\n"

      FileUtils.mkdir_p out unless File.exist? out

      wget_args = [
        '-mnH -p -k --adjust-extension --timeout=50',
        '--waitretry=50 --tries=15 --retry-connrefused'
      ]

      FileUtils.chdir out do

        puts "\n"
        puts "Saving http://localhost:3000#{route_path}"
        puts "\n"

        begin
          `wget #{wget_args.join(' ')} http://localhost:3000#{route_path}`
        rescue NoMethodError => e
          puts e
        end
      end
    end

    Rake::Task['deploy:stop'].invoke

    puts "\n"
    puts "View your files at #{out}"
    puts "\n"
  end

  desc 'Start a HTTP server from ./out/ directory'
  task test: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    Dir.chdir 'out' do

      puts "\n"
      puts "Started HTTP server at http://localhost:8000/#{branch_name}/"
      puts 'Press CTRL+C to exit.'
      puts "\n"

      `python -m SimpleHTTPServer`
    end
  end

  desc 'Stop rails server'
  task stop: :environment do
    File.new('tmp/pids/server.pid').tap { |f| Process.kill 9, f.read.to_i }
    puts "\n"
    puts 'Rails server stopped'
    puts "\n"
  end

  desc 'Starts rails server'
  task start: :environment do
    puts "\n"
    puts 'Server starting...'
    puts "\n"

    `bin/rails s -d`

    puts "\n"
    puts 'Server started'
    puts "\n"
  end

  desc 'Restart rails server'
  task restart: :environment do
    Rake::Task['deploy:stop'].invoke
    Rake::Task['deploy:start'].invoke
  end

  desc 'Compile yarn assets'
  task yarn: :environment do
    `yarn build`
  end

  desc 'Deploy to GitHub Pages'
  task gh_pages: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    puts "\n"
    puts 'Deploying to GitHub Pages...'
    puts "\n"

    `cd out && git add .`
    `cd out && git commit -m 'Deploy to gh-pages'`
    `cd out && git push --force`

    puts "\nDeployed to: https://tech.powerhrg.com/playgrounds/#{branch_name}\n"
  end

  desc 'Cleanup'
  task clean: :environment do
    puts "\nCleaning directory...\n"
    `rm -rf out`
  end

  desc 'Set git worktree'
  task set_worktree: :environment do
    puts "\n"
    puts 'Setting git worktree...'
    puts "\n"

    `mkdir out`

    tree = `git worktree list|grep gh-pages`

    `git worktree add -B gh-pages out origin/gh-pages --force` if tree.empty?
  end

  desc 'Remove git worktree'
  task remove_worktree: :environment do
    puts "\n"
    puts 'Removing git worktree...'
    puts "\n"

    `git worktree prune`
  end

  # 1. Clean directory
  # 2. Add worktree
  # 3. Build
  # 4. Push
  # 5. Prune worktree
end

desc 'Build and deploy your prototype to Playgrounds'
task deploy: [
  'deploy:clean',
  'deploy:set_worktree',
  'deploy:build',
  'deploy:gh_pages',
  'deploy:remove_worktree'
]
