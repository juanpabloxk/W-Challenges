# frozen_string_literal: true

# Stores a job seeker who can apply to job opportunities
class JobSeeker < ApplicationRecord
  has_many :applications, class_name: 'JobApplication', dependent: :destroy, inverse_of: :job_seeker
end
