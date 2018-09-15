module DashboardsHelper

  def color(data)
    if data > 0
      'text-navy'
    else
      'text-danger'
    end
  end

  def arrow(data)
    if data > 0
      'fa-level-up'
    else
      'fa-level-down'
    end
  end
  
end
