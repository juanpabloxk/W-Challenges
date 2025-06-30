# frozen_string_literal: true

# Service to fetch opportunities
class OpportunitiesFetcherService
  include Pagy::Backend

  def initialize(params = {})
    @params = params
  end

  def call
    cache_key = "opportunities-#{@params[:query]}-#{@params[:page]}-#{@params[:per_page]}"

    Rails.cache.fetch(cache_key, expires_in: 2.seconds) do
      scope = Opportunity.includes(:client)
      if @params[:query].present?
        scope = scope.where("title ILIKE :query", query: "%#{@params[:query]}%")
      end

      pagy, opportunities = pagy(scope, items: @params[:per_page] || 10, page: @params[:page] || 1)
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
