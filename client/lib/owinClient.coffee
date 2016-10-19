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


Meteor.getProfile = (path, callback) ->
    hashString = path.context.hash
    a = hashString.split('&')
    query = {}
    i = 0
    while i < a.length
      b = a[i].split('=')
      query[decodeURIComponent(b[0])] = decodeURIComponent(b[1] or '')
      i++
    url = 'https://rocket-sso.auth0.com/userinfo'
    HTTP.get url, { headers:
      'content-type': 'application/json'
      'Authorization': 'Bearer ' + query.access_token }, (err, result) ->
       userinfo = JSON.parse(result.content)
       callback null, userinfo