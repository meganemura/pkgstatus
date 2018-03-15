class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @project.packages.each(&:cache_later)   # Use &:cache to cache now
  end

  def create
    package_names = packages_param.lines
    project = Project.new
    package_names.map(&:strip).uniq.each do |name|
      next if name.blank?
      project.packages << Package.find_or_initialize_by(registry: 'rubygems', name: name)
    end

    if project.save
      redirect_to project_path(project)
    else
      redirect_to root_path
    end
  end

  private

  def packages_param
    params.require(:packages)
  end
end
