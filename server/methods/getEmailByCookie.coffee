Meteor.methods 
  getEmailByCookie: (cookie) ->
    apiUrl = Meteor.settings['public'].apiUrl
    url = apiUrl + '?cookie=' + cookie
    console.log(url)
    result = HTTP.call('POST', url, {'Content-Type': 'application/json'})
    console.log('result from api - ', result)
    result.data
   