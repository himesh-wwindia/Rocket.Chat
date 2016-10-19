Meteor.methods 
  addUserToGroup: (userData) ->
   # check userData.UserId, Number
    check userData.ClassRoomId, String
    now = new Date
    room = RocketChat.models.Rooms.findOne(ClassRoomId: userData.ClassRoomId)
    user = RocketChat.models.Users.findOne(UserId: userData.UserId)
    console.log user
    # Check if user is already in room
    if !user
        apiUrl = Meteor.settings['public'].apiUrl
        url = apiUrl + '?userID=' + userData.UserId
        result = HTTP.call('POST', url)
        console.log result
        if result.data?
           email = result.data.email.toLowerCase()
           newUser =
              name: result.data.name
              username: email
              emails :[{ address: email, verified: false }]
              status: "offline"
              statusDefault: "online"
              utcOffset: 0
              active: true
              type:"user"
              roles:["user"]
              UserId:result.data.id
              DefaultLinkedSubscriptionCode:result.data.DefaultLinkedSubscriptionCode
              profileURL:result.data.profileURL
              profileType:result.data.profileType

          RocketChat.models.Users.create(newUser)
          user = RocketChat.models.Users.findOne(UserId: userData.UserId)

    if room
      subscription = RocketChat.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)
      if subscription
        error = 
          success: false
          messge: 'user already exists.'
          UserId: userData.UserId
        return error
      muted = room.ro and !RocketChat.authz.hasPermission(user._id, 'post-readonly')
      RocketChat.models.Rooms.addUsernameById room._id, user.username, muted
      role = ''
      if userData.IsGroupAdmin == 'true' or userData.IsGroupAdmin == true
        role = 'owner'
      else
        role = 'user'
      RocketChat.models.Subscriptions.createWithRoomAndUser room, user,
        ts: now
        open: true
        alert: true
        unread: 1
        roles: [ role ]
      return { success: true }
    else
    error = 
      success: false
      messge: 'ClassRoomId is not exists.'
      ClassRoomId: userData.ClassRoomId
    error
