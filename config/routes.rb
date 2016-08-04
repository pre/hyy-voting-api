Rails.application.routes.draw do
  # See how all your routes lay out with "rake routes".

  # Grape API in app/api/
  mount API => '/'

end
