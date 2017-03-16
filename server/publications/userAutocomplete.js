Meteor.publish('userAutocomplete', function(selector) {
	if (!this.userId) {
		return this.ready();
	}

	if (!_.isObject(selector)) {
		return this.ready();
	}

	const options = {
		fields: {
			name: 1,
			username: 1,
			status: 1
		},
		sort: {
			username: 1
		},
		limit: 10
	};

	const pub = this;
	const exceptions = selector.exceptions || [];
    var user = RocketChat.models.Users.findOne({
	    username: exceptions[0]
	});
	var flag = false;
	var users = [];
	if (user.roles.indexOf('teacher') !== -1) {
	var chatRoomUsers = RocketChat.models.Rooms.findUserChatRoomByUsername(exceptions[0]);
	chatRoomUsers.forEach(function(doc) {
	  return doc.usernames.forEach(function(user) {
	    if (exceptions[0] !== user) {
	      return users.push(user);
	    }
	  });
	});
	}
	if (users.length === 0) {
	    flag = true;
	}
	const cursorHandle = RocketChat.models.Users.findActiveByUsernameOrNameRegexWithExceptions(selector.term, exceptions, users, flag, options).observeChanges({
		added: function(_id, record) {
			return pub.added('autocompleteRecords', _id, record);
		},
		changed: function(_id, record) {
			return pub.changed('autocompleteRecords', _id, record);
		},
		removed: function(_id, record) {
			return pub.removed('autocompleteRecords', _id, record);
		}
	});

	this.ready();

	this.onStop(function() {
		return cursorHandle.stop();
	});
});


