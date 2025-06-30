# frozen_string_literal: true

# Base class for all application services
# it eases the creation of services by providing a common interface
# it also fosters:
# - the use of a PORO pattern
# - the use of a single responsibility to each service
class ApplicationService
  def self.call(*, **, &)
    new(*, **, &).call
  end
end
