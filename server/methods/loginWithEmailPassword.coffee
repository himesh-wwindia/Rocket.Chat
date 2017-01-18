Meteor.methods
    loginWithEmailPassword: (queryParams) ->
        if queryParams.data?
            data = new Buffer(queryParams.data, 'base64').toString('utf8')
            credential = data.split(';')
            email = credential[0].toLowerCase()
            password = credential[1]
            userId = credential[2]
            chatWithEmail = credential[3]
            user = Meteor.users.findOne({ emails: { $elemMatch: { address: email} } })
            if !user
                apiUrl = Meteor.settings['public'].apiUrl
                url = apiUrl + '?userID=' + userId
                result = HTTP.call('POST', url)
                
                if result.data.profileType == 3
                  role = "admin"
                else
                  role = "user"

                newUser =
                    email: email
                    password: password
                  
                userId = Accounts.createUser(newUser)
                
                update = '$set':
                  'name': result.data.name
                  'username': email
                  'roles': [ role ]
                  'customFields': {
                    'UserId':result.data.id.toString()
                    'profileURL':result.data.profileURL
                    'profileType':result.data.profileType
                    'SubscriptionCode': result.data.SubscriptionCode
                  }
                
                RocketChat.models.Users.update userId, update
                
            result = 
                email:email
                password:password
                chatWithEmail:chatWithEmail
            return result
