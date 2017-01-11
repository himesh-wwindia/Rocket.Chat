Meteor.owinLogin = (email, callback) ->
  #create a login request with admin: true, so our loginHandler can handle this request
  loginRequest =
    owinAuth: true
    data: email
  #send the login request
  Accounts.callLoginMethod
    methodArguments: [ loginRequest ]
    userCallback: callback
  return


