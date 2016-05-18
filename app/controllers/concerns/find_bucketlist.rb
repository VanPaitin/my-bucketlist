module FindBucketlist
  def query_conditions
    {
      id: get_bucketlist_id,
      user_id: current_user.id
    }
  end

  def set_bucketlist
    @bucketlist ||= Bucketlist.find_by(query_conditions)
    render json: { null: "no bucketlist found" }, status: 404 unless @bucketlist

    @bucketlist
  end

  def get_bucketlist_id(controller = params[:controller])
    if controller == "api/v1/items"
      params[:bucketlist_id]
    elsif controller == "api/v1/bucketlists"
      params[:id]
    end
  end
end
