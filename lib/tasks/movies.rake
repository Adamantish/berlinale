namespace :movies do

  task :refresh => :environment do
    ScreeningsImporter.new.process
    SynopsisImporter.new.process
    # SalesProcessor.process
  end

  task update_all_from_html: :environment do
    Screening.all.each do |screening|
      screening.send(:update_from_html)
      screening.save!
    end
  end
end
