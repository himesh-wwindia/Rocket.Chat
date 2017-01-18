Meteor.methods 
  deactivateUser: (ClassRoomId, UserId) ->
    check ClassRoomId, String
    check UserId, String
    room = RocketChat.models.Rooms.findOne(ClassRoomId: ClassRoomId)
    user = RocketChat.models.Users.findOne('customFields.UserId': UserId)
    
    if !user
      error =
        success: false
        messge: 'userId is not exists.'
        userId: userId
      return error
    
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