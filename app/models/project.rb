class Project < ApplicationRecord
  has_many :project_packages
  has_many :packages, through: :project_packages
end
