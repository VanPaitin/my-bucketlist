module FindBucketlist
  def query_conditions
    {
      id: get_bucketlist_id,
      user_id: current_user.id
    }
  end

  def set_bucketlist
    @bucketlist ||= Bucketlist.find_by(query_conditions)
    render json: { error: language.not_found("bucketlist") },
           status: 404 unless @bucketlist
    @bucketlist
  end

  def get_bucketlist_id
    if controller_name == "items"
      params[:bucketlist_id]
    elsif controller_name == "bucketlists"
      params[:id]
    end
  end
end
