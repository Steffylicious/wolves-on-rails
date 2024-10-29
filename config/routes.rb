# frozen_string_literal: true

Rails.application.routes.draw do
  resources :games, only: [:show, :create]
end
