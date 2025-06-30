# frozen_string_literal: true

# Service to fetch opportunities
class OpportunityCreatorService < ApplicationService
  def initialize(opportunity_params)
    @opportunity_params = opportunity_params
  end

  def call
    client = Client.find(@opportunity_params[:client_id])

    if Opportunity.find_by(title: @opportunity_params[:title], client: client).present?
      return [
        { errors: "Title already exists for this client. Use a different title." },
        :unprocessable_entity
      ]
    end

    opportunity = Opportunity.new(@opportunity_params.merge(client: client))

    if opportunity.save
      return { message: "Opportunity created successfully" }, :created
    else
      return { errors: opportunity.errors.full_messages }, :unprocessable_entity
    end
  end
end
