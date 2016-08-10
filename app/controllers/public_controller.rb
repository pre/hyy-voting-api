class PublicController < ApplicationController

  # Environment for the Frontend.
  # Further details in:
  #   1) API `config/frontend_environment.js.erb`
  #   2) Frontend development env: `app/scripts/_environment.js`
  def environment

    # Since Rails is in API mode, ApplicationController does not include
    # ActionView, and we need to render the ERB template manually.
    av = ActionView::Base.new(ActionController::Base.view_paths, view_assigns)
    content = av.render file: "#{Rails.root}/config/frontend_environment.js.erb"

    render js: content
  end
end
