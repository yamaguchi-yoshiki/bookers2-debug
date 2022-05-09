class BooksController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]
  impressionist

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @new_book = Book.new
    @book_comment = BookComment.new
    # DM機能
    @current_user_entry = Entry.where(user_id: current_user.id)
    @user_entry = Entry.where(user_id: @user.id)

    unless @user == current_user
      @current_user_entry.each do |cu|
        @user_entry.each do |u|
          if cu.room_id == u.room_id
            @have_room = true
            @room = cu.room_id
          end
        end
      end
      unless @have_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, alert: "You have destroyed book successfully."
  end

  def sort
    @book = Book.new
    case params[:sort_books]
    when "view"
      @books = Book.order(impressions_count: 'DESC')
    when "favorite"
      @books = Book.all.sort { |a, b| b.favorites.size <=> a.favorites.size }
    when "favorite_this_week"
      @books = Book.all.sort { |a, b| b.favorites.created_this_week.size <=> a.favorites.created_this_week.size }
    else # default(new
      @books = Book.all
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :rate)
  end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end
end
