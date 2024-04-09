# frozen_string_literal: true

module Api::V1
  class UsersController < ApplicationController
    def index
      render json: User.all, status: :ok
    end
  end
end
