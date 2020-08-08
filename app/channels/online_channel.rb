class OnlineChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to OnlineChannel"

    # подписываемся на обновления канала
    stream_from "online_channel"

    # меняем статус пользователя в БД если был офлайн
    current_user.update!(online: true) unless current_user.online

    # формируем паршал текущего юзера
    renderer = ApplicationController.renderer.render(partial: 'users/user', locals: { user: current_user })

    # отправляем паршал и инфу о юзере
    ActionCable.server.broadcast "online_channel", { status: 'on', show: renderer, id: current_user.id }

  end

  def unsubscribed
    logger.info "Unsubscribed to OnlineChannel"

    # инициализируем массив с айдишниками подключенных юзеров
    uid_connections = []

    # заносим айдишники в массив
    ActionCable.server.connections.each do |con|
      uid_connections.push(con.current_user.id)
    end

    # считаем сколько подключений у юзера
    user_connections_counter =
      uid_connections.select { |i| i == current_user.id }.size

    # отправлем инфу о юзере, которого клиент должен удалить со станицы
    if user_connections_counter  < 1
      current_user.update!(online: false)
      ActionCable.server.broadcast "online_channel", { status: 'off', id: current_user.id }
    end
  end
end
