class RoomsController < ApplicationController
  def create
    @room = Room.create
    Entry.create(user_id: current_user.id, room_id: @room.id)
    Entry.create(join_room_params)
    redirect_to room_path(@room)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id, room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      @entries = @room.entries
    else
      flash[:alert] = "部屋が見つかりません"
      redirect_back(fallback_location: users_path)
    end
  end

  private

  def join_room_params
    params.require(:entry).permit(:user_id, :room_id).merge(room_id: @room.id)
  end
end
