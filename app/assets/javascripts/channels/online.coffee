jQuery(document).on 'turbolinks:load', ->
  App.online = App.cable.subscriptions.create "OnlineChannel",
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      { id, nickname, online } = data.user
      # Ищем на странице выведенного юзера
      element = document.getElementById(id)
      # Если статус онлайн и юзер еще не выведен на экран, то выводим
      if online && !element
        $('#online').append("<div class='text-success mr-2' id='#{id}''>#{nickname}</div>")
      # Если статус офлайн, то удаляем
      else if !online
        element.remove()
      