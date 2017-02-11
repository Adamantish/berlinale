namespace :movies do

  task :refresh => :environment do
    ScreeningsImporter.new.process
  end
end
