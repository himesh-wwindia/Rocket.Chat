Meteor.methods 
  getCookieByName: (name) ->

    data = ServerCookies.retrieve(@connection)
    cookies = data and data.cookies
    if cookies and cookies[name] then cookies[name] else null

  logoutUser:(userId) ->
  	  user = Meteor.users.findOne({_id: userId});
