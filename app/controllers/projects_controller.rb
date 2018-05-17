class ProjectsController < ApplicationController
  def show
    @project = Project.find(params[:id])
    @packages = @project.packages.order(:registry, :name).page(params[:page]).per(params[:per])
    @project.packages.each(&:cache_later)   # Use &:cache to cache now
  end

  def create
    project = Project.new
    project.packages =
      packages_for(registry: 'rubygems', names: rubygems_package_names) +
      packages_for(registry: 'npm',      names: npm_package_names)

    if project.save
      redirect_to project_path(project)
    else
      redirect_to root_path
    end
  end

  def destroy
    project = Project.find(params[:id])
    if project.destroy
      redirect_to root_path
    else
      redirect_to project_path(project)
    end
  end

  private

  def packages_param
    params.require(:packages).permit(:rubygems, :npm)
  end

  def packages_for(registry:, names:)
    names.map do |name|
      Package.find_or_initialize_by(registry: registry, name: name)
    end
  end

  def rubygems_package_names
    package_names_for(:rubygems)
  end

  def npm_package_names
    package_names_for(:npm)
  end

  def package_names_for(registry)
    packages_param[registry].lines.flat_map(&:split).uniq
  end
end
