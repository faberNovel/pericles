class MakeRequestToServerService
  def initialize(proxy_configuration, request)
    @proxy_configuration = proxy_configuration
    @request = request
  end

  def execute
    relative_url = @request.path[/proxy\/?(.*)/, 1]
    url = URI.join(target_base_url, relative_url)
    url = URI.join(url.to_s, '?' + @request.query_string) if @request.query_string.present?

    if @proxy_configuration.ignore_ssl
      ctx = OpenSSL::SSL::SSLContext.new
      ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    add_proxy_configuration(HTTP.follow)
      .send(@request.method.downcase, url, body: @request.body.read, headers: headers, ssl_context: ctx)
  end

  def headers
    filtered_headers = @request.headers.env.select { |k, v| v.present? && (k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/) }

    remove_http_prefix(filtered_headers)
    transform_headers_case(filtered_headers)

    filtered_headers.delete('Host')
    filtered_headers
  end

  private

  def add_proxy_configuration(http)
    return http unless @proxy_configuration.use_http_proxy?

    http.via(*@proxy_configuration.http_proxy_fields)
  end

  def target_base_url
    return @target_base_url if defined? @target_base_url

    @target_base_url = @proxy_configuration.target_base_url
    @target_base_url += '/' unless @target_base_url.ends_with? '/'
    @target_base_url
  end

  def remove_http_prefix(headers)
    headers.clone.each_key do |key|
      headers[key[5..-1]] = headers.delete(key) if key =~ /^HTTP_/
    end
  end

  def transform_headers_case(headers)
    headers.clone.each_key do |key|
      headers[key.titleize.tr(' ', '-')] = headers.delete(key)
    end
  end
end
