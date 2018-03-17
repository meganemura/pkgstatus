class Project < ApplicationRecord
  has_many :project_packages, dependent: :destroy
  has_many :packages, through: :project_packages
end
