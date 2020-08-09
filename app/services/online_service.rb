class OnlineService
  def initialize(user:)
    @user = user
  end

  def make_online!
    # меняем статус пользователя в БД если был офлайн
    @user.update!(null: false) if @user.null
    ActionCable.server.broadcast "online_channel",
      { status: 'on', show: render_message, id: @user.id }
  end

  def make_offline!
    # инициализируем массив с айдишниками подключенных юзеров
    uid_connections = []

    # заносим айдишники в массив
    ActionCable.server.connections.each do |con|
      uid_connections.push(con.current_user.id)
    end

    # считаем сколько подключений у юзера
    user_connections_counter =
      uid_connections.select { |i| i == @user.id }.size

    # если у юзера нету других подключений (например в других вкладках браузера)
    # отправлем инфу о юзере, которого клиент должен удалить со станицы
    if user_connections_counter  < 1
      @user.update!(null: true)
      ActionCable.server.broadcast "online_channel",
        { status: 'off', id: @user.id }
    end
  end

  def render_message
    ApplicationController.renderer.render(partial: 'users/user', locals: { user: @user })
  end
end
