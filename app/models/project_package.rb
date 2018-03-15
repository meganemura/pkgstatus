class ProjectPackage < ApplicationRecord
  belongs_to :project
  belongs_to :package
end
