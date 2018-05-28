module AndroidCodeGenHelper
  def android_company_domain_name
    ENV['ANDROID_COMPANY_DOMAIN_NAME'] || 'com.example'
  end
end
