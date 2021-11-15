# frozen_string_literal: true

require 'json/ld'

class ResourceController < ApplicationController
  before_action :set_resource

  def edit
    @title = ResourceService.display_title(@resource, @id)
    @page_title = "Editing: \"#{@title}\""
  end

  def update
    # count an empty update as success
    return render success if sparql_update.empty?

    # send the update
    response = send_to_plastron(@id, @resource[:content_model_name], sparql_update)

    # update passed validation and was applied
    return render success if response.status == 204

    # validation or system errors
    render failure response
  end

  private

    def set_resource
      @id = params[:id]
      @resource = ResourceService.resource_with_model(@id)
    end

    def send_to_plastron(id, model, sparql_update)
      plastron_rest_base_url = ENV['PLASTRON_REST_BASE_URL']
      repo_path = '/' + id.gsub(FCREPO_BASE_URL, '')
      update_url = plastron_rest_base_url + 'resources' + repo_path + '?model=' + model.to_s

      Faraday.new { |f| f.response :json }.patch(update_url) do |request|
        request.headers['Content-Type'] = 'application/sparql-update'
        request.body = sparql_update
      end
    end

    def update_complete
      {
        state: 'update_complete',
        destination: solr_document_url(id: @id)
      }
    end

    def sparql_update
      return @sparql_update if @sparql_update

      delete_statements = (params[:delete] || [])
      insert_statements = (params[:insert] || [])
      return '' if delete_statements.empty? && insert_statements.empty?

      @sparql_update = "DELETE {\n#{delete_statements.join} } INSERT {\n#{insert_statements.join} } WHERE {}"
    end

    def success
      flash[:notice] = t('resource_update_successful')
      { json: update_complete }
    end

    def failure(response)
      @errors = if response.body['title'] == 'Content-model validation failed'
                  # validation errors
                  response.body['validation_errors']
                else
                  # other system errors
                  ['System error: ' + response.body['detail']]
                end
      error_display = render_to_string template: 'resource/_error_display', layout: false
      { json: { state: 'update_failed', errorHtml: error_display, errors: @errors } }
    end
end
