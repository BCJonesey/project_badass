class FlagController < ApplicationController

  def index
    render json: response
  end

  private

    def direction

    end

    def response
      {
        team: 5,
        nextCommand: direction
      }
    end
end
