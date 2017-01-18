Meteor.methods 
  activateUser: (ClassRoomId, UserId) ->
    check ClassRoomId, String
    check UserId, String
    room = RocketChat.models.Rooms.findOne(ClassRoomId: ClassRoomId)
    user = RocketChat.models.Users.findOne('customFields.UserId': UserId)
    if !user
      error =
        success: false
        messge: 'UserId is not exists.'
        UserId: UserId
      return error
    if room
      unmutedUser = RocketChat.models.Users.findOneByUsername(user.username)
      RocketChat.models.Rooms.unmuteUsernameByRoomId room._id, unmutedUser.username
      success = 
        success: true
      return success 
    else
      error =
        success: false
        messge: 'ClassRoomId is not exists.'
      error