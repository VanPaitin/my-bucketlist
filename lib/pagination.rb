class Pagination
  attr_reader :limit, :page, :query_object, :offset_param, :size
  def initialize(params, query_object)
    pagination_params(params)
    @query_object = query_object
    @size = query_object.count
  end

  def pagination_params(params)
    @page = get_page_params(params[:page])
    @limit = get_limit_params(params[:limit])
    @offset_param = (page - 1) * limit
  end

  def get_page_params(pg)
    pg ||= 1
    pg = pg.to_i
    pg > 0 ? pg : 1
  end

  def get_limit_params(lim)
    lim = lim.to_i
    lim = lim >= 1 ? lim : 20
    lim.between?(1, 100) ? lim : 100
  end

  def paginate
    result = query_object.offset(offset_param).limit(limit)
    return nil if result.empty?
    {
      bucketlist: ActiveModel::ArraySerializer.new(result),
      info_summary: set_meta_tag
    }
  end

  # methods for setting meta tags

  def set_total_pages
    limit > size ? 1 : (size / limit.to_f).ceil
  end

  def set_limit
    limit > size ? size : limit
  end

  def set_meta_tag
    {
      current_page: page,
      records_per_page: set_limit,
      total_pages: set_total_pages,
      total_records: size
    }
  end
end
