class PackagesController < ApplicationController
  def show
    @package = Package.find_by(registry: params[:registry], name: params[:package])
  end
end
