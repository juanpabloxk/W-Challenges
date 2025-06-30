# frozen_string_literal: true

# Service to fetch opportunities
class OpportunitiesFetcherService < ApplicationService
  include Pagy::Backend

  def initialize(params = {})
    @params = params
    @per_page = (params[:per_page] || 10).clamp(1, 100)
  end

  def call
    cache_key = "opportunities-#{@params[:query]}-#{@params[:page]}-#{@per_page}"

    Rails.cache.fetch(cache_key, expires_in: 15.minutes) do
      scope = Opportunity.includes(:client)
      if @params[:query].present?
        scope = scope.where("title ILIKE :query", query: "%#{@params[:query]}%")
      end

      pagy, opportunities = pagy(scope, items: @per_page, page: @params[:page] || 1)
      {
        opportunities: opportunities.as_json(include: { client: { only: [ :id, :name ] } }),
        pagination: {
          count: pagy.count,
          page: pagy.page,
          items: pagy.items,
          pages: pagy.pages,
          prev: pagy.prev,
          next: pagy.next
        }
      }
    end
  end

  private

  # This is needed for pagy to access the params
  def params
    @params
  end
end
