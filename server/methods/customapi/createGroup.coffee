Meteor.methods 
  createNewGroup: (group) ->
    try
      check group.Name, String
      check group.ClassRoomId, String
      
      # Get room/group record by using ClassRoomId
      room = RocketChat.models.Rooms.findOne(ClassRoomId: group.ClassRoomId)
      
      # if room/group is exists then chnage group name otherwise 
      # create new group.
      if room?
        name = group.Name
        RocketChat.models.Rooms.setNameById room._id, name
        return true
      else
        groupData =
          name: group.Name
          t: 'p'
          usernames: []
          msgs: 0
          u:
            _id: null
            username: null
          ClassRoomId: group.ClassRoomId
          allowStudentTochatTogether:group.allowStudentTochatTogether
        
        group = RocketChat.models.Rooms.insert(groupData)
        return group

    catch error
      console.error error
    return