Accounts.registerLoginHandler (loginRequest) ->
  #there are multiple login handlers in meteor.
  #a login request go through all these handlers to find it's login hander
  #so in our login handler, we only consider login requests which has admin field
  console.log(loginRequest)
  if !loginRequest.owinAuth
    return undefined
  #our authentication logic :)

  #we create a admin user if not exists, and get the userId
  userId = null
  email = loginRequest.data.email.toLowerCase()
  user = Meteor.users.findOne({ emails: { $elemMatch: { address: email} } })
  console.log(user)
  if user
    userId = user._id
  else
    if loginRequest.data.email?
      
      if loginRequest.data.profileType == 3
        role = "admin"
      else
        role = "user"
      
      newUser =
          email: email
          password: loginRequest.data.DefaultLinkedSubscriptionCode
        
      userId = Accounts.createUser(newUser)
      
      update = '$set':
        'name': loginRequest.data.name
        'username': email
        'roles': [ role ]
        'UserId':loginRequest.data.id.toString()
        'profileURL':loginRequest.data.profileURL
        'profileType':loginRequest.data.profileType
      
      RocketChat.models.Users.update userId, update

  return { userId: userId }
  #send loggedin user's user id