class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @project.packages.each(&:cache_later)   # Use &:cache to cache now
  end
end
