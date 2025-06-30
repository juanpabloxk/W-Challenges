# frozen_string_literal: true

# Stores a job opportunity which job seekers can apply to
class Opportunity < ApplicationRecord
  belongs_to :client, inverse_of: :opportunities
  has_many :applications, class_name: 'JobApplication', dependent: :destroy, inverse_of: :opportunity

  validates :title, :description, :salary, presence: true
  validates :salary, numericality: { greater_than: 0 }
end
