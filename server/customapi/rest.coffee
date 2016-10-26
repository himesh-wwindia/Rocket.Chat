bodyParser = Npm.require('body-parser');
async = Npm.require('async');
Picker.middleware bodyParser.urlencoded(extended: true)
Picker.middleware bodyParser.json()

WebApp.connectHandlers.use (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Methods', 'POST,GET,OPTIONS,PUT,DELETE'
  res.setHeader 'Access-Control-Allow-Headers', 'Content-Type, Access-Control-Allow-Headers,  X-Requested-With'
  res.setHeader 'Content-Type', 'application/json'
  next()


post = Picker.filter((req, res) ->
  req.method == 'POST'
)

post.route '/api/v1/createUser', (params, req, res, next) ->

  try
    if req.body.users?
      ids = []
      Users = req.body.users
      async.each Users, ((singleUser, callback) ->
        uid = Meteor.call 'createNewUser', singleUser
        ids.push uid: uid
        callback
      ), ->
        
      if ids[0].uid?
        res.statusCode = 200
        res.end JSON.stringify({success:true, ids:ids})
      else
        res.statusCode = 404
        res.end JSON.stringify(
          success : false
          message: 'user already exists.')
    else
      res.statusCode = 422
      res.end JSON.stringify(
        success : false
        message: 'data parameters not correct.')
  catch e
    console.log e


post.route '/api/v1/createGroup', (params, req, res, next) ->
  
  try
    if req.body.Name? and req.body.ClassRoomId?
      group = req.body
      group.t = "p"
      groupId = Meteor.call 'createNewGroup', group
      
      if groupId
        statusMessage = {success: true}
        res.statusCode = 200
        res.end JSON.stringify(statusMessage)
      else
        res.statusCode = 422
        res.end JSON.stringify(
          success : false
          message: 'group name already exists.')
    else
      res.statusCode = 400
      res.end JSON.stringify(
        success : false
        message: 'data parameters not correct.')
  catch e
    console.log e
  

post.route '/api/v1/activateDeactivateGroup' , (params, req, res, next) ->

  try
    if req.body.ClassRoomId? and req.body.IsActive?
      data = req.body
     
      result = Meteor.call 'activateDeactivateGroup', data

      if result.success
        res.statusCode = 200
        res.end JSON.stringify(result)
      else
        res.statusCode = 404
        res.end JSON.stringify(result)
    else
      res.statusCode = 422
      res.end JSON.stringify(
        success : false
        message: 'data parameters not correct.')
  catch e
    console.log e


post.route '/api/v1/addUsersToGroup' , (params, req, res, next) ->

  try
    if req.body.users?
      Users = req.body.users
      isUserAdded = '';
      async.each Users, ((singleUser, callback) ->
        isUserAdded = Meteor.call 'addUserToGroup', singleUser
        callback
      ), ->
      
      if isUserAdded.success
        res.statusCode = 200
        res.end JSON.stringify({success: true})
      else
        res.statusCode = 404
        res.end JSON.stringify(isUserAdded)
    else
      res.statusCode = 422
      res.end JSON.stringify(
        success : false
        message: 'data parameters not correct.')
  catch e
    console.log e


post.route '/api/v1/deleteUsersFromGroup' , (params, req, res, next) ->

  try
    if req.body.UserIds? and req.body.ClassRoomId?
      Users = req.body.UserIds
      ClassRoomId = req.body.ClassRoomId
      isUserRemoved = false
      async.each Users, ((singleUser, callback) ->
        isUserRemoved = Meteor.call 'removeUserFromGroup', ClassRoomId, singleUser
        callback
      ), ->

      if isUserRemoved.success
       res.statusCode = 200
       res.end JSON.stringify({success: true})
      else
       res.statusCode = 404
       res.end JSON.stringify(isUserRemoved)
    else
      res.statusCode = 422
      res.end JSON.stringify(
        success : false
        message: 'data parameters not correct.')
  catch e
    console.log e
  

post.route '/api/v1/activateUsersInGroup', (params, req, res, next) ->
  try
    if req.body.UserIds? and req.body.ClassRoomId?
      unmuteUser = ''
      Users = req.body.UserIds
      ClassRoomId = req.body.ClassRoomId
      async.each Users, ((singleUser, callback) ->
        unmuteUser = Meteor.call('activateUser', ClassRoomId, singleUser)
        callback
      ), ->
        
      if unmuteUser.success
        res.statusCode = 200
        res.end JSON.stringify({success: true})
      else
        res.statusCode = 404
        res.end JSON.stringify(unmuteUser)
    else
      res.setHeader 'Content-Type', 'application/json'
      res.statusCode = 422
      res.end JSON.stringify(
        message: 'data parameters not correct.')
  catch e
    console.log e

post.route '/api/v1/deactivateUsersInGroup', (params, req, res, next) ->
  try
    if req.body.UserIds? and req.body.ClassRoomId?
      muteUser = ''
      Users = req.body.UserIds
      ClassRoomId = req.body.ClassRoomId
      async.each Users, ((singleUser, callback) ->
        muteUser = Meteor.call('deactivateUser', ClassRoomId, singleUser)
        callback
      ), ->

      if muteUser.success
        res.statusCode = 200
        res.end JSON.stringify({success: true})
      else
        res.statusCode = 404
        res.end JSON.stringify(muteUser)
    else
      res.statusCode = 422
      res.end JSON.stringify(
        message: 'data parameters not correct.')
  catch e
    console.log e
  


    


