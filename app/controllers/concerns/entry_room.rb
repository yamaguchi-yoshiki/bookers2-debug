module EntryRoom
extend ActiveSupport::Concern

  included do
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
end
