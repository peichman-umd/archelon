# frozen_string_literal: true

require 'test_helper'

class PlastronServiceTest < ActiveSupport::TestCase
  def setup
    @import_job_id = 'http://localhost:3000/import_jobs/5'
    ENV['PLASTRON_REST_BASE_URL'] = 'http://localhost:5000/'
  end

  test 'retrieve_import_job_info returns ImportJobInfo with error on exception' do
    stub_request(:any, "http://localhost:5000/jobs/#{CGI.escape(@import_job_id)}")
      .to_raise(StandardError.new('An error occurred'))

    import_job_info = PlastronService.retrieve_import_job_info(@import_job_id)
    assert import_job_info.error_occurred?
    assert_equal('An error occurred', import_job_info.error_message)
  end

  test 'retrieve_import_job_info returns ImportJobInfo with error if PLASTRON_REST_BASE_URL not set' do
    ENV['PLASTRON_REST_BASE_URL'] = nil
    import_job_info = PlastronService.retrieve_import_job_info(@import_job_id)
    assert import_job_info.error_occurred?
    assert_equal('PLASTRON_REST_BASE_URL not set', import_job_info.error_message)
  end

  test 'retrieve_import_job_info returns ImportJobInfo with parsed JSON on success' do
    json_fixture_file = 'services/import_job/plastron_job_detail_response.json'
    stub_request(:get, "http://localhost:5000/jobs/#{CGI.escape(@import_job_id)}")
      .to_return(status: 200, body: file_fixture(json_fixture_file).read, headers: {})

    import_job_info = PlastronService.retrieve_import_job_info(@import_job_id)
    assert_not import_job_info.error_occurred?

    assert_equal(2, import_job_info.completed.count)
    assert_equal(4, import_job_info.total)
  end
end
