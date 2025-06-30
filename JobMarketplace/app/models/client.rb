# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Stores a client who can post job opportunities
class Client < ApplicationRecord
  has_many :opportunities, dependent: :destroy, inverse_of: :client

  validates :name, presence: true
end
