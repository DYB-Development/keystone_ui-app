# frozen_string_literal: true

Rails.application.routes.draw do
  get "/pages/plain", to: "pages#plain"
end
