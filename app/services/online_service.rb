class OnlineService
  def initialize(user:)
    @user = user
  end

  def make_online!
    # меняем статус пользователя в БД если был офлайн
    @user.update!(online: true) unless @user.online
    broadcast @user
  end

  def make_offline!
    user_connections =
      ActionCable.server.connections.
      # считаем сколько подключений у юзера
      select { |con| con.current_user.id == @user.id }

    # если у юзера нету других подключений (например в других вкладках браузера)
    # отправлем инфу о юзере, которого клиент должен удалить со станицы
    if user_connections.empty?
      @user.update!(online: false)
      broadcast @user
    end
  end

  private

  def broadcast(user)
    ActionCable.server.broadcast "online_channel",
      { user: user }
  end
end
