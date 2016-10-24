Meteor.methods
	loginWithEmailPassword: (queryParams) ->
		console.log queryParams
		if queryParams.data?
			data = new Buffer(queryParams.data, 'base64').toString('utf8')
			console.log data
			credential = data.split(';')
			result = 
				email:credential[0]
				password:credential[1]
			return result