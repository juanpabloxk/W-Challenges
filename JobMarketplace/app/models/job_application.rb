# frozen_string_literal: true

# Stores a job application for a job opportunity
# connects a job seeker to a job opportunity
class JobApplication < ApplicationRecord
  belongs_to :job_seeker, inverse_of: :job_applications
  belongs_to :opportunity, inverse_of: :job_applications
end
