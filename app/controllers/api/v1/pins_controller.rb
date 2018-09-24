class Api::V1::PinsController < ApplicationController
  before_action :authenticate_api!

  def index
      render json: Pin.all.order('created_at DESC')
  end

  def create
      pin = Pin.new(pin_params)
      if pin.save
        render json: pin, status: 201
      else
        render json: { errors: pin.errors }, status: 422
      end
  end

  private
    def pin_params
      params.require(:pin).permit(:title, :image_url)
    end

    def authenticate_api!
      email = request.headers['HTTP_X_USER_EMAIL']
      token = request.headers['HTTP_X_API_TOKEN']
      @current_user = User.where(email: email).take
      unless @current_user && @current_user.api_token == token
        head 401
      end
    end
end