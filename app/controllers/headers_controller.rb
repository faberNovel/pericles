class HeadersController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        term = params[:term] ? params[:term] : ""
        @found_headers = Header.ransack(name_cont: term).result(distinct: true).select(:name)
        render json: @found_headers, status: :ok
      end
    end
  end
end