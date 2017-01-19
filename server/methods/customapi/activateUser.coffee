Meteor.methods 
  activateUser: (ClassRoomId, UserId) ->
    check ClassRoomId, String
    check UserId, String
    # Get room/group record by using ClassRoomId
    room = RocketChat.models.Rooms.findOne(ClassRoomId: ClassRoomId)
    # Get user record by using UserId
    user = RocketChat.models.Users.findOne({ customFields: { $elemMatch: { UserId: UserId } } })

    # if user is available then activate user in room otherwise 
    # send error UserId is not exists.
    if !user
      error =
        success: false
        messge: 'UserId is not exists.'
        UserId: UserId
      return error

    # if room/group is available then activate user in room otherwise 
    # send error ClassRooomId is not exist.
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