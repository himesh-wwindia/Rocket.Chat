Meteor.publish 'userAutocomplete', (selector) ->
    unless this.userId
        return this.ready()

    if not _.isObject selector
        return this.ready()

    options =
        fields:
            name: 1
            username: 1
            status: 1
        sort:
            username: 1
        limit: 10

    pub = this

    exceptions = selector.exceptions or []
    # get current loggedIn user
    user = RocketChat.models.Users.findOne(username: exceptions[0])
    flag = false
    users = []
    # if user has teacher who can chat only users in group have allowStudentTochatTogether is true.
    if user.roles.indexOf('teacher') != -1
        # get users in which group have allowStudentTochatTogether is true.
        chatRoomUsers = RocketChat.models.Rooms.findUserChatRoomByUsername(exceptions[0])
        chatRoomUsers.forEach (doc) ->
          doc.usernames.forEach (user) ->
            if exceptions[0] != user
                users.push user
        
    # if users length is 0 then don't show any users for direct message.
    if users.length == 0
        flag = true
        
           
    cursorHandle = RocketChat.models.Users.findActiveByUsernameOrNameRegexWithExceptions(selector.term, exceptions, users, flag, options).observeChanges
        added: (_id, record) ->
            pub.added("autocompleteRecords", _id, record)

        changed: (_id, record) ->
            pub.changed("autocompleteRecords", _id, record)

        removed: (_id, record) ->
            pub.removed("autocompleteRecords", _id, record)
    
    @ready()
    @onStop ->
        cursorHandle.stop()
    return
