class OnlineChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to OnlineChannel"

    # подписываемся на обновления канала
    stream_from "online_channel"

    # делаем юзера онлайн и выводим на странице с помощью сервиса
    OnlineService.new(user: current_user).make_online!
  end

  def unsubscribed
    logger.info "Unsubscribed to OnlineChannel"

    # делаем юзера оффлайн и убираем со страницы с помощью сервиса
    OnlineService.new(user: current_user).make_offline!
  end
end
