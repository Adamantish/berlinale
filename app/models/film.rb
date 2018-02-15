class Film < ActiveRecord::Base
  has_many :screenings

  def calc_average_sellout_minutes
    results = screenings.to_a.map!(&:calc_average_sale_duration).reject(&:zero?)
    return nil unless results.present?
    results.sum / results.count
  end
end
