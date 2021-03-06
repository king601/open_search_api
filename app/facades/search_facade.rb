class SearchFacade
  attr_reader(:params)

  def initialize(params)
    @params = params
  end

  # Public: previous_searches
  # Returns an AR collection of previously searched terms.
  # These are displayed on the sidebar to provide clickable links for viewing
  # previously searched terms by users.
  def previous_searches
    SearchTerm.filter_query(params[:filter_by])
  end

  # Public: search_activity
  # Returns an AR collection that's used in the views to display all previous
  # search times when viewing search results.
  # Limited to only select the created_at for performance reasons.
  def search_activity
    Search.where(search_term: search_term).select(:created_at)
  end

  # Public: results
  # Returns a JSON from NASA API Service Class
  # if params[:search] is present
  def results
    return nil unless params[:search].present?
    NasaImages.new(query_params).search
  end

  private

  def query_params
    { search: params[:search] }
  end

  def search_term
    SearchTerm.find_by_query(params[:search])
  end
end
