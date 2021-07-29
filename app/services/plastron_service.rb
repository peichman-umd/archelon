# frozen_string_literal: true

# Service for retrieving information from Plastron
class PlastronService
  # Contacts the Plastron /jobs/<path:job_id> endpoint and returns ImportJobInfo
  def self.retrieve_import_job_info(import_job_id)
    job_url = construct_import_job_url(import_job_id)
    json_rest_result = query_server(job_url)
    ImportJobInfo.new(json_rest_result)
  rescue StandardError => e
    json_rest_result = JsonRestResult.create_error_result(e.to_s)
    ImportJobInfo.new(json_rest_result)
  end

  # Returns the Plastron URL to query from the given job id (which is
  # assumed to have the form 'http://localhost:3000/import_jobs/5')
  def self.construct_import_job_url(import_job_id)
    plastron_rest_base_url = ENV['PLASTRON_REST_BASE_URL']
    raise StandardError, 'PLASTRON_REST_BASE_URL not set' if plastron_rest_base_url.nil?

    job_relative_path = "jobs/#{import_job_id}"
    Addressable::URI.join(plastron_rest_base_url, job_relative_path)
  end

  # Performs the GET request to the given URL, returning a JsonRestResult
  def self.query_server(job_url)
    body = HTTP.get(job_url).body
    JsonRestResult.create_from_json(body.to_s)
  rescue StandardError => e
    JsonRestResult.create_error_result(e.to_s)
  end
end
