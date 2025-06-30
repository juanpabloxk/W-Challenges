# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :opportunities, only: %i[index create] do
        post :apply, on: :member
      end
    end
  end
end
