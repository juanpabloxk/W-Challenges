# frozen_string_literal: true

# RateLimiter class for managing request rate limiting
class RateLimiter
  def initialize(time_window, max_requests)
    @time_window = time_window
    @max_requests = max_requests
    @requests = Hash.new { |hash, key| hash[key] = [] }
  end

  def allow_request?(timestamp, user_id)
    # Clean up expired requests (older than time_window)
    cutoff_time = timestamp - @time_window
    @requests[user_id].reject! { |time| time < cutoff_time }

    # Check if we're under the limit
    if @requests[user_id].length < @max_requests
      @requests[user_id] << timestamp
      return true
    end

    false
  end
end
