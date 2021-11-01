# frozen_string_literal: true

# Channel for Import Jobs
class ImportJobsChannel < ApplicationCable::Channel
  def subscribed
    @classname = params[:classname]
    job = find_job(@classname, params[:id])
    return unless job

    Rails.logger.debug("Received subscription for #{@classname} #{job.id} from user #{username}")
    stream_for job if authorized_to_stream job
  end

  # Called by the client with an import job id. This method triggers an
  # immediate status update job, where server will send a broadcast message
  # to trigger a status update on the client.
  #
  # This method is intended to work around an issue where the client has
  # missed a status update for an import job (such as validation) and there
  # are no further updates, which otherwise would leave the client thinking
  # the job was still in an "in progress" state.
  def import_job_status_check(data)
    job = find_job(@classname, data['jobId'])
    return unless job

    ImportJobStatusUpdatedJob.perform_now(job)
  end

  private

    def username
      current_user.cas_directory_id
    end

    def find_job(classname, id)
      klass = classname.constantize
      klass.find(id)
    rescue NameError
      Rails.logger.warning("Unknown class name: #{classname}")
    end

    # confirm that the current user should be able to subscribe to this import job
    def authorized_to_stream(job)
      if current_user.admin? || job.cas_user == current_user
        Rails.logger.debug("Streaming #{@classname} #{job.id} for user #{username}")
        true
      else
        Rails.logger.warning("User #{username} does not have permission to view #{@classname} #{job.id}")
        false
      end
    end
end
