namespace :proxy do
  desc 'Clean reports older than 3 days'
  task clean_reports: :environment do
    Report.where('created_at < ?', 3.days.ago).destroy_all
  end

  task validate_reports: :environment do
    Report.where(validated: false).find_each do |report|
      ReportValidator.new(report).validate
    end
  end
end
