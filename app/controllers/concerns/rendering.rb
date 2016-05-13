module Rendering
  def successful_rendering(object, status)
    render json: object, status: status,
           location: [:api, :v1, object], root: false
  end

  def error_rendering(object)
    render json: { errors: object.errors }, status: 422
  end
end