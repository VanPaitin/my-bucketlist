class Languages
  def successful_creation
    "Successfully created"
  end

  def successful_deletion(object)
    object + " deleted successfully"
  end

  def forbidden
    "You are not allowed to perform this action"
  end

  def not_found(object)
    object + " could not be found"
  end

  def expired_token
    "Expired token, login again"
  end

  def not_authenticated
    "Not Authenticated. invalid or missing token"
  end

  def invalid_endpoint
    "Invalid endpoint, check documentation for more details"
  end

  def login
    "Successfully logged in"
  end

  def logout
    "You are logged out now"
  end

  def invalid_email
    "please pass in a valid email address"
  end

  def wrong_email_or_password
    "invalid email/password combination"
  end
end
