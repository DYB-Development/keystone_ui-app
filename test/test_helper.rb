# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "rails/test_help"

Rails.application.config.action_dispatch.show_exceptions = :none
