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
  user = Meteor.users.findOne({ emails: { $elemMatch: { address: loginRequest.email} } })
  console.log(user)
  if user
    userId = user._id
  #send loggedin user's user id
  return { userId: userId }
