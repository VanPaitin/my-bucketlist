module TimeStamps
  extend ActiveSupport::Concern
  included do
    validates_presence_of :name
  end

  def date_created
    created_at.strftime("%A, #{created_at.day.ordinalize} %B %Y at %I:%M %p")
  end

  def date_modified
    updated_at.strftime("%A, #{updated_at.day.ordinalize} %B %Y at %I:%M %p")
  end
end
