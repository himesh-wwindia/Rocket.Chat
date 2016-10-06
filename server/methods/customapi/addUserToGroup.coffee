Meteor.methods 
  addUserToGroup: (userData) ->
    check userData.UserId, String
    check userData.ClassRoomId, String
    now = new Date
    room = RocketChat.models.Rooms.findOne(ClassRoomId: userData.ClassRoomId)
    user = RocketChat.models.Users.findOne(UserId: userData.UserId)
    # Check if user is already in room
    if !user
      error = 
        success: false
        messge: 'userId is not exists.'
        UserId: userData.UserId
      return error
    if room
      subscription = RocketChat.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)
      if subscription
        error = 
          success: false
          messge: 'user already exists.'
          UserId: userData.UserId
        return error
      muted = room.ro and !RocketChat.authz.hasPermission(user._id, 'post-readonly')
      RocketChat.models.Rooms.addUsernameById room._id, user.username, muted
      role = ''
      if userData.IsGroupAdmin == 'true'
        role = 'owner'
      else
        role = 'user'
      RocketChat.models.Subscriptions.createWithRoomAndUser room, user,
        ts: now
        open: true
        alert: true
        unread: 1
        roles: [ role ]
      return { success: true }
    else
    error = 
      success: false
      messge: 'ClassRoomId is not exists.'
      ClassRoomId: userData.ClassRoomId
    error
