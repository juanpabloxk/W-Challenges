# frozen_string_literal: true

# == Schema Information
#
# Table name: opportunities
#
#  id          :bigint           not null, primary key
#  title       :string
#  description :text
#  salary      :decimal(, )
#  client_id   :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Stores a job opportunity which job seekers can apply to
class Opportunity < ApplicationRecord
  belongs_to :client, inverse_of: :opportunities
  has_many :job_applications, dependent: :destroy, inverse_of: :opportunity

  validates :title, :description, :salary, presence: true
  validates :salary, numericality: { greater_than: 0 }
end
