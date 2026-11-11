# frozen_string_literal: true

Rails.application.routes.draw do
  get "/pages/plain", to: "pages#plain"
  get "/pages/no_footer", to: "pages#no_footer"
  get "/pages/show", to: "pages#show"
  get "/pages/form", to: "pages#form"
  get "/pages/header", to: "pages#header"
  get "/pages/no_bottom_tabs", to: "pages#no_bottom_tabs"
  get "/pages/add", to: "pages#add"
  get "/pages/post_add", to: "pages#post_add"
  get "/pages/native_form", to: "pages#native_form"
  get "/pages/show_actions", to: "pages#show_actions"
  get "/pages/form_action", to: "pages#form_action"
  get "/pages/add_menu", to: "pages#add_menu"
  get "/pages/more", to: "pages#more"
  get "/pages/account", to: "pages#account"

  mount KeystoneUi::App::Engine, at: "/"
end
