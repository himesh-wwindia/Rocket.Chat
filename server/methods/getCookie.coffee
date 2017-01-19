Meteor.methods 
  getCookieByName: (name) ->
    # get cookie from browser.
    data = ServerCookies.retrieve(@connection)
    cookies = data and data.cookies
    # if cookie exist return cokkie otherwise null
    if cookies and cookies[name] then cookies[name] else null

  logoutUser:(userId) ->
      # get user by using userId.
  	  user = Meteor.users.findOne({_id: userId});
