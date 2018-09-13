module DashboardsHelper

  def arrow(data)
    if data > 0
      'text-navy'
    else
      'text-danger'
    end
  end
  
end
