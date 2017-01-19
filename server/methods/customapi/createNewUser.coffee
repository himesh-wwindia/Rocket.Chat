Meteor.methods 
  createNewUser: (user) ->
      try
        check user.Email, String
        check user.UserName, String
        check user.UserLogo, String
        check user.UserId, String
        
        # check email is valid or not or email is already exists in database.
        RocketChat.validateEmailDomain user.Email
        password = Meteor.settings['private'].password
        userData =
          email: user.Email.toLowerCase()
          password: password
        
        userId = Accounts.createUser(userData)
        
        role = ''
        if user.IsAdminUser == 'true'  or user.IsAdminUser == true
          role = 'admin'
        else
          role = 'user'
        
        update = '$set':
          'name': user.UserName
          'username': user.UserName
          'roles': [ role ]
          'customFields': {
            'UserId': user.UserId
            'UserLogo': user.UserLogo
            'GuidId': user.GuidId
          }

      
        RocketChat.models.Users.update userId, update
        return userId

      catch error
        console.error error
      return
