# frozen_string_literal: true

# == Schema Information
#
# Table name: job_seekers
#
#  id         :bigint           not null, primary key
#  name       :string
#  email      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class JobSeeker < ApplicationRecord
  has_many :job_applications, dependent: :destroy, inverse_of: :job_seeker
end
