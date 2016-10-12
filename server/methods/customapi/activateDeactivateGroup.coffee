Meteor.methods 
  activateDeactivateGroup: (data) ->
    try
      check data.ClassRoomId, String
      room = RocketChat.models.Rooms.findOne(ClassRoomId: data.ClassRoomId)
      if room
        if data.IsActive == 'true' or data.IsActive == true
          RocketChat.models.Rooms.unarchiveById(room._id)
          RocketChat.models.Subscriptions.unarchiveByRoomId(room._id)
          return {
            success: true
            IsActive: data.IsActive
          }
        else
          RocketChat.models.Rooms.archiveById(room._id)
          RocketChat.models.Subscriptions.archiveByRoomId(room._id)
          return {
            success: true
            IsActive: data.IsActive
          }
      else
        error = 
          success: false
          messge: 'ClassRoomId is not exist.'
        return error
    catch error
      console.error error
    return
