class FlagController < ApplicationController

  def index
    # render text: "callback(#{response_data.to_json})"
    render json: response_data
  end

  private

    def direction
      dirs = %w(N E S W)
      dirs.reject! { |dir| %W(WALL OOB).include? tiles[dir] }
      puts dirs.inspect
      dirs.sort! do |a,b|
        if care_about.include?(a)
          if care_about.include?(b)
            0
          else
            1
          end
        else
          if care_about.include?(b)
            -1
          else
            0
          end
        end
      end
      puts dirs.inspect

      if dirs.length > 1
        return dirs.second if Random.new.rand < 0.25
      end
      return dirs.first
    end

    def response_data
      {
        team: 5,
        nextCommand: direction
      }
    end

    def x
      tiles['location']['x']
    end

    def y
      tiles['location']['y']
    end

    def furthest
      @furthest ||= x.abs > y.abs ? :x : :y
    end

    def care_about
      return %w(E W) if furthest == :x
      return %w(N S) if furthest == :y
    end

    def tiles
      @tiles ||= JSON.parse params[:tiles]
    end
end
