Meteor.methods
    loginWithEmailPassword: (queryParams) ->
        if queryParams.data?
            data = new Buffer(queryParams.data, 'base64').toString('utf8')
            credential = data.split(';')
            email = credential[0].toLowerCase()
            password = credential[1]
            user = Meteor.users.findOne({ emails: { $elemMatch: { address: email} } })
            if !user
                newUser =
                    email: email
                    password: password
                  
                userId = Accounts.createUser(newUser)
                update = '$set':
                  'username': email

                RocketChat.models.Users.update userId, update

            result = 
                email:email
                password:password
            return result