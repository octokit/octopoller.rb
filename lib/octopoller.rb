require "octopoller/version"

module Octopoller
  class TimeoutError < StandardError; end
  class TooManyAttemptsError < StandardError; end

  # Polls until success
  # Re-runs when the block returns `:re_poll`
  #
  # wait      - The time delay in seconds between polls (default is 1 second)
  #           - When given the argument `:exponentially` the action will be retried with exponetial backoff
  # timeout   - The maximum number of seconds the poller will execute
  # retries   - The maximum number of times the action will be retried
  # yield     - A block that will execute, and if `:re_poll` is returned it will re-run
  #           - Re-runs until something is returned or the timeout/retries is reached
  # raise     - Raises an Octopoller::TimeoutError if the timeout is reached
  # raise     - Raises an Octopoller::TooManyAttemptsError if the retries is reached
  def poll(wait: 1, timeout: nil, retries: nil, errors: [])
    wait = 0 if [nil, false].include?(wait)
    errors = Array(errors)
    Octopoller.validate_arguments(wait, timeout, retries, errors)

    exponential_backoff = (wait == :exponentially)
    error = nil
    wait = 0.25 if exponential_backoff

    if timeout
      start = Time.now.utc
      while Time.now.utc < start + timeout
        begin
          block_value = yield
        rescue *errors => error
          block_value = :re_poll
        end
        return block_value unless block_value == :re_poll
        sleep wait
        wait *= 2 if exponential_backoff
      end
      raise TimeoutError.new("Polling timed out patiently"), cause: error
    else
      (retries + 1).times do
        begin
          block_value = yield
        rescue *errors => error
          block_value = :re_poll
        end
        return block_value unless block_value == :re_poll
        sleep wait
        wait *= 2 if exponential_backoff
      end
      raise TooManyAttemptsError.new("Polled maximum number of attempts"), cause: error
    end
  end

  def self.validate_arguments(wait, timeout, retries, errors)
    if (timeout.nil? && retries.nil?) || (timeout && retries)
      raise ArgumentError, "Must pass an argument to either `timeout` or `retries`"
    end
    exponential_backoff = wait == :exponentially
    raise ArgumentError, "Cannot wait backwards in time" if !exponential_backoff && wait.negative?
    raise ArgumentError, "Timed out without even being able to try" if timeout&.negative?
    raise ArgumentError, "Cannot retry something a negative number of times" if retries&.negative?
    unless errors.all? { |error| error.is_a?(Class) && error < StandardError }
      raise ArgumentError, "Errors must be classes that inherit from StandardError"
    end
  end

  module_function :poll
end
