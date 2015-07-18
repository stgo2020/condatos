class PagesController < ApplicationController
  def home
    @tracks = Track.accessible_by(current_ability)
  end

  def about
  end
end
