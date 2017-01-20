Meteor.methods 
  addUserToGroup: (userData) ->
   # check userData.UserId, Number
    check userData.ClassRoomId, String
    now = new Date
    room = RocketChat.models.Rooms.findGroupByCustomField(userData.ClassRoomId)
    user = RocketChat.models.Users.findUserByCustomField(userData.UserId)
    
    # Check if user is exists otherwise add user in application
    if !user
        # call rest api and get user details from edaura application.
        apiUrl = Meteor.settings['public'].apiUrl
        url = apiUrl + '?userID=' + userData.UserId
        result = HTTP.call('POST', url)
        if result.data?
          email = result.data.email.toLowerCase()
          
          if result.data.profileType == 3
            role = "admin"
          else
            role = "user"

          newUser =
              email: email
              password: result.data.SubscriptionCode
            
          userId = Accounts.createUser(newUser)
          
          update = '$set':
            'name': result.data.name
            'username': email
            'roles': [ role ]
            'customFields':{
              'UserId':result.data.id.toString()
              'profileURL':result.data.profileURL
              'profileType':result.data.profileType
              'SubscriptionCode': result.data.SubscriptionCode
            }
          
          RocketChat.models.Users.update userId, update
          user = RocketChat.models.Users.findUserByCustomField(userData.UserId)
    
    # if room is available add user to group.
    if room
      subscription = RocketChat.models.Subscriptions.findOneByRoomIdAndUserId(room._id, user._id)
      # if user already added in group then send response as user already exists.
      if subscription
        error = 
          success: false
          messge: 'user already exists.'
          UserId: userData.UserId
        return error
      muted = room.ro and !RocketChat.authz.hasPermission(user._id, 'post-readonly')
      RocketChat.models.Rooms.addUsernameById room._id, user.username, muted
      role = ''
      
      # if IsGroupAdmin is true set role as group owner otherwise as user.
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