class SearchesController < ApplicationController
  def search_result
    
  end

  def search
    @range = params[:range]
    @word = params[:word]
    if @range == "User"
      @users = User.looks(params[:search],params[:word])
    else
      @books = Book.looks(params[:search],params[:word])
    end
    render 'search_result'
  end
end
