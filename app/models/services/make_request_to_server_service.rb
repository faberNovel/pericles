class MakeRequestToServerService

  def initialize(server_url, request)
    @server_url = server_url
    @request = request
  end

  def execute
    url = @server_url + @request.path
    begin
      RestClient.send(@request.method.downcase, url, {params: @request.params})
    rescue RestClient::ExceptionWithResponse => e
      e.response
    end
  end
end
