class MakeRequestToServerService

  def initialize(server_url, request)
    @server_url = server_url
    @request = request
  end

  def execute
    url = URI.join(@server_url, @request.params[:path])
    url = URI.join(url.to_s, '?' + @request.query_string) unless @request.query_string.blank?

    HTTP.send(@request.method.downcase, url, body: @request.body.read, headers: headers)
  end

  def headers
    filtered_headers = @request.headers.env.select{|k, v| !v.blank? && (k.in?(ActionDispatch::Http::Headers::CGI_VARIABLES) || k =~ /^HTTP_/) }

    remove_http_prefix(filtered_headers)
    transform_headers_case(filtered_headers)

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
