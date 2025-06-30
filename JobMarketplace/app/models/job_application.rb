class JobApplication < ApplicationRecord
  belongs_to :opportunity
  belongs_to :job_seeker
end
