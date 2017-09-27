class MakeRequestToServerService

  def initialize(server_url, request)
    @server_url = server_url
    @request = request
  end

  def execute
    url = URI.join(@server_url, @request.params[:path])
    url = URI.join(url.to_s, '?' + @request.query_string) unless @request.query_string.blank?

    HTTP.send(@request.method.downcase, url, body: @request.body.read)
  end
end
