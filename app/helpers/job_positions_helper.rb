module JobPositionsHelper
  def job_position_items
    JobPosition.all.map{|e| [e.name, e.id]}
  end
end
