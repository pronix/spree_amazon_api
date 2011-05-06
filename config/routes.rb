Rails.application.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resource :amazon, :only => [:show, :edit, :update], :controller => :amazon

  end
end
