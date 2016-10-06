Meteor.methods 
  removeUserFromGroup: (ClassRoomId, UserId) ->
    room = RocketChat.models.Rooms.findOne(ClassRoomId: ClassRoomId)
    user = RocketChat.models.Users.findOne(UserId: UserId)
    if !user
      error = 
        success: false
        messge: 'UserId is not exists.'
        UserId: UserId
      return error
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
