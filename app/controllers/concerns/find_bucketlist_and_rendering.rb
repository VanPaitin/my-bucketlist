module FindBucketlistAndRendering
  def query_conditions(controller = params[:controller])
    bucketlist_id = if controller == "api/v1/items"
                      params[:bucketlist_id]
                    elsif controller == "api/v1/bucketlists"
                      params[:id]
                    end
    { id: bucketlist_id, user_id: current_user.id }
  end

  def set_bucketlist
    @bucketlist = Bucketlist.find_by(query_conditions)
    if @bucketlist
      @bucketlist
    else
      render json: { null: "no bucketlist found" }, status: 404
    end
  end

  def successful_rendering(object, status)
    render json: object, status: status, root: false
  end

  def error_rendering(object)
    render json: { errors: object.errors }, status: 422
  end
end
