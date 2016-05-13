module TimeStamps
  def date_created
    created_at.strftime("#{created_at.day.ordinalize} %B %Y")
  end

  def date_modified
    updated_at.strftime("#{updated_at.day.ordinalize} %B %Y")
  end
end
