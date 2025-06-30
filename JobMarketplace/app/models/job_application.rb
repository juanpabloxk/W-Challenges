# frozen_string_literal: true

# == Schema Information
#
# Table name: job_applications
#
#  id             :bigint           not null, primary key
#  opportunity_id :bigint           not null
#  job_seeker_id  :bigint           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class JobApplication < ApplicationRecord
  belongs_to :job_seeker, inverse_of: :job_applications
  belongs_to :opportunity, inverse_of: :job_applications
end
