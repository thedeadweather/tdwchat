jQuery(document).on 'turbolinks:load', ->
  messages = $('#messages')

  if messages.length > 0
    createRoomChannel messages.data('room-id')

  $(document).on 'keypress', '#message_body', (event) ->
    message = event.target.value
    #если нажали enter и поле сообщения не пустое
    if event.keyCode is 13 && message != ''
      #создаем сообщение
      App.room.speak(message)
      #удаляем из формы текст
      event.target.value = ""
      event.preventDefault()
    #запрещаем сабмитить пустое текстовое поле нажатием enter
    else if event.keyCode is 13
      return false

createRoomChannel = (roomId) ->
  App.room = App.cable.subscriptions.create {channel: "RoomChannel", roomId: roomId},
    connected: ->
      # Called when the subscription is ready for use on the server

    disconnected: ->
      # Called when the subscription has been terminated by the server

    received: (data) ->
      # Called when there's incoming data on the websocket for this channel
      messages = $('#messages')
      messages.append data['message']
      #скролим блок с сообщениями в конец, где добавилось новое сообщение
      messages[0].scrollTop = messages[0].scrollHeight

    speak: (message) ->
      @perform 'speak', message: message
