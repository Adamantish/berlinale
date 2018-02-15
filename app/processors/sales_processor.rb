module SalesProcessor
  class << self
    def process(pretend: false)
      changed_films = []
      relevant_film_ids = Screening.pluck(:film_id).uniq
      ActiveRecord::Base.transaction do
        Film.where(id: relevant_film_ids).find_each do |film|
          screenings = film.screenings.to_a
          next unless screenings.present?
          avg_minutes = film.calc_average_sellout_minutes
          next unless avg_minutes.present?
          # TODO: Very temporary approach to approximate retainment of some of the lost data
          # Assumes a lot and should be deleted soon
          # if film.average_sellout_minutes
          #   avg_minutes = (film.average_sellout_minutes + avg_minutes) / 2
          # end
          film.average_sellout_minutes = avg_minutes
          changed_films << film if film.changed?
          film.save! unless pretend
        end
      end

      if changed_films.present?
        p "#{pretend ? 'Just for pretend:' : ''} Updated sale values for these" 
        changed_films.each do |film|
          p film.attributes.slice('id', 'title',  'average_sellout_minutes')
        end
      else
        p 'No film sales details to update'
      end
    end
  end
end