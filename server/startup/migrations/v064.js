RocketChat.Migrations.add({
	version: 64,
	up: function() {
		RocketChat.models.Rooms.tryDropIndex('name_1');
	}
});	
