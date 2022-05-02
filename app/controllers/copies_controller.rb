class CopiesController < ApplicationController
  def index
    copies = Copy.since(params[:since])
    render json: copies
  end

  def show
    formatted_copy = Copy.find(params[:key]).formatted(request.query_parameters)
    render json: formatted_copy
  end

  def refresh
    Copies::Refresh.new.call
  end
end
