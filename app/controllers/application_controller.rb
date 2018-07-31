class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include Pundit
  rescue_from ActionController::ParameterMissing, with: :params_missing
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_params
  rescue_from ActiveRecord::RecordInvalid, with: :bad_params
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from ActionController::UrlGenerationError, with: :no_route

  def params_missing(error)
    render json: { error: [error.message] }, status: :forbidden
  end

  def unpermitted_params(error)
    render json: { error: [error.message] }, status: :forbidden
  end

  def bad_params(error)
    render json: { error: [error.record.errors.full_messages] }, status: :forbidden
  end

  def record_not_found(error)
    render json: { error: [error.message] }, status: :not_found
  end

  def user_not_authorized(error)
    render json: { error: [error.message] }, status: :unauthorized
  end

  # def no_route(error)
  #   binding.pry
  #   render json: { error: error }, status: :forbidden
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # devise default adds password & password_confirmation for sign_up
    # https://github.com/plataformatec/devise/blob/master/lib/devise/parameter_sanitizer.rb#L38
    added_attrs = %i[username email email_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    # devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
