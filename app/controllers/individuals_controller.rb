# frozen_string_literal: true

class IndividualsController < ApplicationController
  load_and_authorize_resource

  # GET /individuals
  # GET /individuals.json
  def index
    @individuals = Individual.all
  end

  # GET /individuals/1
  # GET /individuals/1.json
  def show
  end

  # GET /individuals/new
  def new
    @individual = Individual.new
    @individual.vocabulary_id = params[:vocabulary] if params[:vocabulary]
  end

  # GET /individuals/1/edit
  def edit
  end

  # POST /individuals
  # POST /individuals.json
  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    @individual = Individual.new(individual_params)

    respond_to do |format|
      if @individual.save
        format.html do
          redirect_to @individual.vocabulary,
                      notice: "#{t('activerecord.models.individual')} #{@individual.label} was successfully created."
        end
        format.json { render :show, status: :created, location: @individual }
      else
        format.html { render :new }
        format.json { render json: @individual.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /individuals/1
  # PATCH/PUT /individuals/1.json
  def update # rubocop:disable Metrics/MethodLength
    respond_to do |format|
      if @individual.update(individual_params)
        format.html do
          redirect_to @individual, notice: "#{t('activerecord.models.individual')} was successfully updated."
        end
        format.json { render :show, status: :ok, location: @individual }
      else
        format.html { render :edit }
        format.json { render json: @individual.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /individuals/1
  # DELETE /individuals/1.json
  def destroy
    @individual.destroy
    respond_to do |format|
      format.html do
        redirect_to individuals_url, notice: "#{t('activerecord.models.individual')} was successfully deleted."
      end
      format.json { head :no_content }
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def individual_params
      params.require(:individual).permit(:identifier, :label, :same_as, :vocabulary_id)
    end
end
