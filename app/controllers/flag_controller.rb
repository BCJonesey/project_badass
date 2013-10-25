class FlagController < ApplicationController

  def index
    render text: "jsonCallback(#{response_data.to_json})"
  end

  private

    def data
      @data ||= JSON.parse params[:data]
    end

    def direction
      # Score higher if toward center
      dirs['N'] += 1 if y < 0
      dirs['E'] += 1 if x < 0
      dirs['S'] += 1 if y > 0
      dirs['W'] += 1 if x > 0

      # Attack teams (why not?)
      dirs.keys.each { |dir| dirs[dir] += 1 if data[dir] == 'TEAM' }

      # Avoid walls
      dirs.reject! { |dir,score| %W(WALL OOB).include? data[dir] }

      # Sort by score desc
      choices = dirs.sort { |a,b| b[1] <=> a[1] }.map(&:first)

      # Choose first 75% of time, else choose second
      if choices.length > 1
        return choices.second if Random.new.rand < 0.25
      end
      return choices.first
    end

    def dirs
      @dirs ||= %w(N E S W).inject({}) { |h,k| h.merge! k => 0 }
    end

    def response_data
      {
        team: 5,
        nextCommand: direction
      }
    end

    def x
      data['x']
    end

    def y
      data['y']
    end

    # def old_direction
    #   dirs = %w(N E S W)
    #   dirs.reject! { |dir| %W(WALL OOB).include? data[dir] }
    #   puts dirs.inspect
    #   dirs.sort! do |a,b|
    #     if care_about.include?(a)
    #       if care_about.include?(b)
    #         0
    #       else
    #         1
    #       end
    #     else
    #       if care_about.include?(b)
    #         -1
    #       else
    #         0
    #       end
    #     end
    #   end
    #   puts dirs.inspect

    #   if dirs.length > 1
    #     return dirs.second if Random.new.rand < 0.25
    #   end
    #   return dirs.first
    # end

    # def furthest
    #   @furthest ||= x.abs > y.abs ? :x : :y
    # end

    # def care_about
    #   return %w(E W) if furthest == :x
    #   return %w(N S) if furthest == :y
    # end
end
