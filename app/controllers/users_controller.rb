class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new

    # 日数別投稿数
    @today = Time.zone.now.strftime("%-m月 %-d日")
    @today_book = @books.created_today
    @yesterday = 1.day.ago.strftime("%-m月 %-d日")
    @yesterday_book = @books.created_yesterday
    @two_days_ago = 2.day.ago.strftime("%-m月 %-d日")
    @two_days_ago_book = @books.created_2days_ago
    @three_days_ago = 3.day.ago.strftime("%-m月 %-d日")
    @three_days_ago_book = @books.created_3days_ago
    @four_days_ago = 4.day.ago.strftime("%-m月 %-d日")
    @four_days_ago_book = @books.created_4days_ago
    @five_days_ago = 5.day.ago.strftime("%-m月 %-d日")
    @five_days_ago_book = @books.created_5days_ago
    @six_days_ago = 6.day.ago.strftime("%-m月 %-d日")
    @six_days_ago_book = @books.created_6days_ago
    # 前日比
    if @yesterday_book.count == 0
      @the_day_before = false
    else
      @the_day_before = @today_book.count / @yesterday_book.count.to_f * 100
    end
    # 週別投稿数
    @this_week_book = @books.created_this_week
    @last_week_book = @books.created_last_week
    # 先週比
    if @last_week_book.count == 0
      @the_week_before = false
    else
      @the_week_before = @this_week_book.count / @last_week_book.count.to_f * 100
    end
    # グラフ
    @chartlabels = [@six_days_ago, @five_days_ago, @four_days_ago, @three_days_ago, @two_days_ago, @yesterday, @today]
    @chartdatas = @this_week_book

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
