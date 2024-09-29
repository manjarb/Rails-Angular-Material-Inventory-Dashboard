require 'ostruct'

module PaginationUtils
  def self.pagination_meta(paginated_collection, limit)
    {
      current_page: paginated_collection.current_page,
      total_pages: paginated_collection.total_pages,
      total_count: paginated_collection.total_count,
      limit: limit,
      next_page: paginated_collection.next_page,
      prev_page: paginated_collection.prev_page
    }
  end

  def self.paginate_array(items, page, per_page)
    total_count = items.size
    total_pages = (total_count / per_page.to_f).ceil
    paginated_items = items.slice((page - 1) * per_page, per_page)

    # Compute limit, next_page, and prev_page
    limit = paginated_items.size
    next_page = page < total_pages ? page + 1 : nil
    prev_page = page > 1 ? page - 1 : nil

    # Return paginated result as an OpenStruct
    OpenStruct.new(
      current_page: page,
      total_pages: total_pages,
      total_count: total_count,
      limit: limit,
      next_page: next_page,
      prev_page: prev_page,
      items: paginated_items
    )
  end

  def self.extract_pagination_params(params, default_page, default_limit)
    page = params[:page].to_i > 0 ? params[:page].to_i : default_page
    limit = params[:limit].to_i > 0 ? params[:limit].to_i : default_limit
    { page: page, limit: limit }
  end
end
