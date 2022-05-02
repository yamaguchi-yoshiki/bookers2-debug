class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 投稿数
    @today_book = @books.created_today
    @yesterday_book = @books.created_yesterday
    if @yesterday_book.count == 0
      @the_day_before = false
    else
      @the_day_before = @today_book.count / @yesterday_book.count.to_f * 100
    end
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    if @last_week_book.count == 0
      @the_week_before = false
    else
      @the_week_before = @this_week_book.count / @last_week_book.count.to_f * 100
    end

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
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def search
    @user = User.find(params[:user_id])
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @created_book = "日付を選択してください"
    else
      create_at = params[:created_at]
      @created_book = @books.where(["created_at LIKE ? ", "#{create_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
