module ApplicationHelper
  
  def flush_the_flash
    str = ""
    if flash[:error] then
      str += "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>×</button>" + flash[:error] + "</div>"
    end
    if flash[:notice] then
      str += "<div class='alert alert-success'><button type='button' class='close' data-dismiss='alert'>×</button>" + flash[:notice] + "</div>"
      
    end
    if flash[:info] then
      str += "<div class='alert alert-error'><button type='button' class='close' data-dismiss='alert'>×</button>" + flash[:info] + "</div>"
    end
    raw(str)
  end
end
