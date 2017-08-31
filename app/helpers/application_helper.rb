module ApplicationHelper
  def active_class(link_path)
     if request.fullpath == link_path
       "active"
     else
       ""
     end
  end
end
