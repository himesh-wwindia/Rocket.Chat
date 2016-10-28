Meteor.methods 
  createNewGroup: (group) ->
    try
      check group.Name, String
      check group.ClassRoomId, String
      
      room = RocketChat.models.Rooms.findOne(ClassRoomId: group.ClassRoomId)
      if !room
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
      else
        name = group.Name
        RocketChat.models.Rooms.setNameById room._id, name
        return true

    catch error
      console.error error
    return