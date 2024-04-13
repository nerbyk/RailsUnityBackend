# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def not_found
    head :not_found
  end

  def unprocessable_entity(error)
    render json: ErrorSerializer.serialize(error.record.errors), status: :unprocessable_entity
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email])
  end
end
