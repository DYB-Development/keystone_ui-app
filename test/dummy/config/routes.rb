# frozen_string_literal: true

Rails.application.routes.draw do
  get "/pages/plain", to: "pages#plain"
  get "/pages/no_footer", to: "pages#no_footer"
  get "/pages/show", to: "pages#show"
end
