namespace :proxy  do
  desc "Clean reports older than 3 days"
  task :clean_reports => :environment do
    Report.where("created_at < ?", 3.days.ago).destroy_all
  end
end
