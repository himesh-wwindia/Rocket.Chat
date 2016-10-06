Meteor.methods 
  createNewUser: (user) ->
      try
        check user.Email, String
        check user.UserName, String
        check user.UserLogo, String
        check user.UserId, String
       
        RocketChat.validateEmailDomain user.Email
        password = Meteor.settings['private'].password
        userData =
          email: user.Email.toLowerCase()
          password: password
        
        userId = Accounts.createUser(userData)
        
        role = ''
        if user.IsAdminUser == 'true'
          role = 'admin'
        else
          role = 'user'
        
        update = '$set':
          'name': user.UserName
          'username': user.UserName
          'UserId': user.UserId
          'UserLogo': user.UserLogo
          'GuidId': user.GuidId
          'roles': [ role ]
        
        RocketChat.models.Users.update userId, update
        return userId

      catch error
        console.error error
      return
