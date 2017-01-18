Meteor.methods 
  getEmailByCookie: (cookie) ->
    apiUrl = Meteor.settings['public'].apiUrl
    url = apiUrl + '?cookie=' + cookie
    result = HTTP.call('POST', url, {'Content-Type': 'application/json'})
    result.data
   