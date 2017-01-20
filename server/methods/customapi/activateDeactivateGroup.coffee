Meteor.methods 
  activateDeactivateGroup: (data) ->
    try
      check data.ClassRoomId, String
      # Get room/group record by using ClassRoomId
      room = RocketChat.models.Rooms.findGroupByCustomField(data.ClassRoomId)
      # if room/group is exists then activate deactivate room otherwise 
      # send error ClassRooomId is not exist.
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
