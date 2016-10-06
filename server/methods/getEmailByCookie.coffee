Meteor.methods 
  getEmailByCookie: (cookie) ->
    apiUrl = Meteor.settings['public'].apiUrl
    url = apiUrl + '' + cookie
    result = HTTP.call('POST', url)
    result.content