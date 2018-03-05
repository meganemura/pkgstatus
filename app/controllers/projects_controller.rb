class ProjectsController < ApplicationController
  def show
    @project = Project.find(SecureRandom.uuid)
    @project.packages.each(&:cache_later)   # Use &:cache to cache now
  end
end
