Rails.application.routes.draw do
  devise_for :users
  resources :docs

  get 'docs/:id/export_word' => 'docs#export_word', :as => :download

  authenticated :user do
    root 'docs#index', as: "authenticated_root"
  end

  root 'welcome#index'
end
