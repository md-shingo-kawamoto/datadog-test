class HealthController < ApplicationController
  def index
    render json: { status: 'ok', timestamp: Time.current }
  end
end

