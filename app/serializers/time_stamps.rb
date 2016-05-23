module TimeStamps
  def date_created
    object.created_at.strftime(
      "%A, #{object.created_at.day.ordinalize} %B %Y at %I:%M %p"
    )
  end

  def date_modified
    object.updated_at.strftime(
      "%A, #{object.updated_at.day.ordinalize} %B %Y at %I:%M %p"
    )
  end
end
