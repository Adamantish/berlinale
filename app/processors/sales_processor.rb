module SalesProcessor
  class << self
    def process
      changed_films = []
      relevant_film_ids = Screening.pluck(:film_id).uniq
      ActiveRecord::Base.transaction do
        Film.where(id: relevant_film_ids).find_each do |film|
          screenings = film.screenings.to_a
          next unless screenings.present?
          film.average_sellout_minutes = screenings.sum(&:calc_average_sale_duration) / screenings.count
          changed_films << film if film.changed?
          # film.save!
        end
      end

      if changed_films.present?
        p "Would have Updated sale values for these" 
        changed_films.each do |film|
          p film
        end
      else
        p 'No film sales details to update'
      end
    end
  end
end