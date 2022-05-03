class CopiesController < ApplicationController
  def index
    copies = Copy.since(params[:since])
    render json: copies
  end

  def show
    copy = Copy.find(params[:key])
    if copy
      render json: copy.formatted(request.query_parameters)
    else
      render json: { error: "copy not found" }, status: :not_found
    end
  end

  def refresh
    Copy.refresh
  end
end
