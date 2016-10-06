Meteor.methods 
  createNewGroup: (group) ->
    try
      check group.Name, String
      check group.ClassRoomId, String
      
      groupData =
        name: group.Name
        t: 'c'
        usernames: []
        msgs: 0
        u:
          _id: null
          username: null
        ClassRoomId: group.ClassRoomId
      
      group = RocketChat.models.Rooms.insert(groupData)
      return group
    catch error
      console.error error
    return