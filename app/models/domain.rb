class Domain < ApplicationRecord

  # def calculate_points
  #   binding.pry
  #   points = 0
  #   urls = Url.where(domain: self.domain)
  #   count = urls.count
  #   if count > 0
  #     urls.each do |url|
  #       points += url.points
  #     end
  #     self.update(points: points)
  #     self.update(urls_count: count)
  #     self.update(average: points/count)
  #   end
  #   self.points
  # end

end
