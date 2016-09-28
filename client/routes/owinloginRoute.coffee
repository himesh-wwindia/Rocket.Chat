
FlowRouter.route '/',
  name: 'owinlogin'
  action: ->
    BlazeLayout.render 'main', center: 'owinForm'
    return

FlowRouter.route '/callback',
  name: 'callback'
  action: ->
    path = FlowRouter.current()
    Meteor.getProfile path , (err, result) ->
	    Meteor.owinLogin result.email, (error) ->
	        FlowRouter.go 'home'
	        return


FlowRouter.route '/login',
	name: 'login'

	action: ->
	    BlazeLayout.render 'main', center: 'owinForm'
	    return
