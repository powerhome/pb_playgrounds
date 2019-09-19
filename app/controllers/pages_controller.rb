class PagesController < ApplicationController
  # layout "nitro";

  def index
    render template: 'pages/welcome'
  end
end
