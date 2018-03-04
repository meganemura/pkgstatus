class ProjectsController < ApplicationController
  def show
    @project = Project.find(SecureRandom.uuid)
    @project.packages.each(&:cache_later)
  end
end
