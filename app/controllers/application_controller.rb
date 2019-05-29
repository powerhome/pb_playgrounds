class ApplicationController < ActionController::Base
  helper Playbook::PbKitHelper
  append_view_path Playbook::Engine.root + "app/pb_kits/playbook"
end
