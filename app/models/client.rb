# frozen_string_literal: true

# Stores a client who can post job opportunities
class Client < ApplicationRecord
  has_many :opportunities, dependent: :destroy, inverse_of: :client
end
