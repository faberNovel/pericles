namespace :proxy do
  desc 'Clean reports older than 1 month'
  task clean_reports: :environment do
    Report.where('created_at < ?', 1.month.ago).find_each(batch_size: 200, &:destroy)
  end

  task validate_reports: :environment do
    Report.where(validated: false).find_each do |report|
      ReportValidator.new(report).validate
    end
  end
end
