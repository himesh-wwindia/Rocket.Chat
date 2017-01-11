Meteor.startup ->
   RocketChat.models.Rooms.tryDropIndex('name_1');
