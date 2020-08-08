jQuery(document).on 'turbolinks:load', ->
  App.online = App.cable.subscriptions.create "OnlineChannel",
    connected: ->
      # Called when the subscription is ready for use on the server
      console.log('Connected to OnlineChannel')

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      # Выводим статус пользователя в консоли
      console.log('User with id' + data['id'] + ' is ' + data['status'] + 'line')
      # Ищем на странице выведенного юзера
      element = document.getElementById(data['id']);
      # Если статус онлайн и юзер еще не выведен на экран, то выводим
      if data['status'] == 'on' && !element
        $('#online').append data['show']
      # Если статус офлайн, то удаляем
      else if data['status'] == 'off'
        element.remove()
      
