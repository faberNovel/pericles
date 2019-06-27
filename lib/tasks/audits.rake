namespace :audits do
  task slack_post: :environment do
    Project.where.not(slack_channel: [nil, '']).map do |project|
      news_posted_count = PostSlackNews.new(project).execute
      puts "#{news_posted_count} news posted on #{project.slack_channel} for project #{project.id}"
    end
  end
end
