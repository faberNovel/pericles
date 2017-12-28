class MakeRequestToServerService

  def initialize(proxy_url, request)
    @proxy_url = proxy_url
    @proxy_url += '/' unless @proxy_url.ends_with? '/'
    @request = request
  end

  def execute
    relative_url = @request.path[/proxy\/?(.*)/, 1]
    url = URI.join(@proxy_url, relative_url)
    url = URI.join(url.to_s, '?' + @request.query_string) unless @request.query_string.blank?

    HTTP.follow.send(@request.method.downcase, url, body: @request.body.read, headers: headers)
  end

  def headers
    filtered_headers = @request.headers.env.select{|k, v| !v.blank? && (k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/) }

    remove_http_prefix(filtered_headers)
    transform_headers_case(filtered_headers)

    filtered_headers.delete('Host')
    filtered_headers
  end

  private
  def remove_http_prefix(headers)
    headers.clone.each_key do |key|
      headers[key[5..-1]] = headers.delete(key) if key =~ /^HTTP_/
    end
  end

  def transform_headers_case(headers)
    headers.clone.each_key do |key|
      headers[key.titleize.tr(" ", "-")] = headers.delete(key)
    end
  end
end
