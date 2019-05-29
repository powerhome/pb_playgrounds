namespace :deploy do
  desc "TODO"
  task build: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    sh 'rm -rf out'
    require 'action_dispatch/routing/inspector'
    all_routes = Rails.application.routes.routes.map do |route|
      {alias: route.name, path: route.path.spec.to_s, controller: route.defaults[:controller], action: route.defaults[:action]}
    end
    allowed_controllers = ["pages"]
    all_routes.reject! {|route| !allowed_controllers.include?(route[:controller])}

    inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
    all_routes.each do |route|
      Dir.mkdir 'out' unless File.exists? 'out'
      Dir.mkdir "out/#{branch_name}" unless File.exists? "out/#{branch_name}"
      Dir.chdir "out/#{branch_name}" do
        `wget -mnH -p -k --adjust-extension http://localhost:3000#{route[:path]}`
      end
    end;nil
    # Need to account for not overwriting `git subtree push --prefix dist origin gh-pages`
    puts "View your files at out/#{branch_name}"
  end


  desc 'Run tiny HTTP server from ./out/ directory'
  task server: :environment do
    branch_name = `git rev-parse --abbrev-ref HEAD`.chomp
    Dir.chdir 'out' do
      puts "Started HTTP server at http://localhost:8000/#{branch_name}/ Press CTRL+C to exit."
      `python -m SimpleHTTPServer`
    end
  end

  desc "TODO"
  task my_task2: :environment do
  end

end
