# frozen_string_literal: true

class SellingController < ApplicationController
  include KeystoneUi::App::AreaGuard

  in_area "Selling"

  def show
    respond_to do |format|
      format.html { render plain: "Selling page" }
      format.json { render json: { page: "selling" } }
    end
  end
end
