Meteor.methods 
  removeUserFromGroup: (ClassRoomId, UserId) ->
    room = RocketChat.models.Rooms.findGroupByCustomField(ClassRoomId)
    user = RocketChat.models.Users.findUserByCustomField(UserId)
    
    # if user is not exists then send response userId is not exists.
    if !user
      error = 
        success: false
        messge: 'UserId is not exists.'
        UserId: UserId
      return error
    
    # if room is exists remove user from group.
    if room
      RocketChat.models.Rooms.removeUsernameById room._id, user.username
      RocketChat.models.Subscriptions.removeByRoomIdAndUserId room._id, user._id
      return { success: true }
    else
      error = 
        success: false
        messge: 'ClassRoomId is not exists.'
        ClassRoomId: ClassRoomId
      error
