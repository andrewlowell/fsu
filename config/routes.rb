Rails.application.routes.draw do

  root to: "images#index"

  get '/auth/:provider/callback', to: 'familysearch#auth'

  resources :images, only: [:index, :create, :show]

  get '/familysearch/post_pic/:id/:filename', to: 'familysearch#post_pic', as: :post_pic

  get 'familysearch/create_description/:id', to: 'familysearch#create_description', as: :create_desription

  get 'dropbox/upload', to: 'dropbox#upload', as: :upload2db

  get 'dropbox/authenticate/:id', to: 'dropbox#authenticate', as: :authenticate2db

  devise_for :users

end
