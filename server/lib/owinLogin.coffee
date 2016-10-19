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
      name = email.substring(0, email.lastIndexOf('@'))
      newUser =
            name: loginRequest.data.name
            username: email
            emails :[{ address: email, verified: false }]
            status: "offline"
            statusDefault: "online"
            utcOffset: 0
            active: true
            type:"user"
            roles:["user"]
            UserId:loginRequest.data.id
            DefaultLinkedSubscriptionCode:loginRequest.data.DefaultLinkedSubscriptionCode
            profileURL:loginRequest.data.profileURL
            profileType:loginRequest.data.profileType


      userId = RocketChat.models.Users.create(newUser)

  return { userId: userId }
  #send loggedin user's user id
