Meteor.methods 
  deactivateUser: (ClassRoomId, UserId) ->
    check ClassRoomId, String
    check UserId, String
    room = RocketChat.models.Rooms.findGroupByCustomField(ClassRoomId)
    user = RocketChat.models.Users.findUserByCustomField(UserId)
    
    # if user is not exists then send response userId is not exists.
    if !user
      error =
        success: false
        messge: 'userId is not exists.'
        userId: userId
      return error
    
    # if room is exists deactivate user from group.
    if room
      mutedUser = RocketChat.models.Users.findOneByUsername(user.username)
      RocketChat.models.Rooms.muteUsernameByRoomId room._id, mutedUser.username
      success = 
        success: true
      return success   
    else
      error =
        success: false
        messge: 'ClassRoomId is not exists.'
      error