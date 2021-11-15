# frozen_string_literal: true

# Message used when there is an error communicating with Plastron
class PlastronExceptionMessage < PlastronMessage
  def initialize(exception_msg)
    @exception_msg = exception_msg
  end

  def ok?
    false
  end

  def job_state
    'exception'
  end

  def error_message
    @exception_msg
  end
end
