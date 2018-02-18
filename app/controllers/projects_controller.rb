class ProjectsController < ApplicationController
  def show
    @project = Project.find(SecureRandom.uuid)
  end
end
