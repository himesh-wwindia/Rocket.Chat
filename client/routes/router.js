/* globals KonchatNotification */

Blaze.registerHelper('pathFor', function(path, kw) {
	return FlowRouter.path(path, kw.hash);
});

BlazeLayout.setRoot('body');

FlowRouter.subscriptions = function() {
	Tracker.autorun(() => {
		if (Meteor.userId()) {
			this.register('userData', Meteor.subscribe('userData'));
			this.register('activeUsers', Meteor.subscribe('activeUsers'));
		}
	});
};


// FlowRouter.route('/', {
// 	name: 'index',
// 	action() {
// 		BlazeLayout.render('main', { modal: RocketChat.Layout.isEmbedded(), center: 'loading' });
// 		if (!Meteor.userId()) {
// 			return FlowRouter.go('home');
// 		}

// 		Tracker.autorun(function(c) {
// 			if (FlowRouter.subsReady() === true) {
// 				Meteor.defer(function() {
// 					if (Meteor.user().defaultRoom) {
// 						const room = Meteor.user().defaultRoom.split('/');
// 						FlowRouter.go(room[0], { name: room[1] }, FlowRouter.current().queryParams);
// 					} else {
// 						FlowRouter.go('home');
// 					}
// 				});
// 				c.stop();
// 			}
// 		});
// 	}
// });


// FlowRouter.route('/login', {
// 	name: 'login',

// 	action() {
// 		FlowRouter.go('home');
// 	}
// });

// FlowRouter.route('/home', {
// 	name: 'home',

// 	action(params, queryParams) {
// 		RocketChat.TabBar.showGroup('home');
// 		KonchatNotification.getDesktopPermission();
// 		if (queryParams.saml_idp_credentialToken !== undefined) {
// 			Accounts.callLoginMethod({
// 				methodArguments: [{
// 					saml: true,
// 					credentialToken: queryParams.saml_idp_credentialToken
// 				}],
// 				userCallback: function() { BlazeLayout.render('main', {center: 'home'}); }
// 			});
// 		} else {
// 			BlazeLayout.render('main', {center: 'home'});
// 		}
// 	}
// });

FlowRouter.route('/', {
  name: 'index',
  action: function() {
    var context;
    //Get context object from current url.
    context = FlowRouter.current();
    // check context having data query params.
    if (context.queryParams.hasOwnProperty('data')) {
       //if user is already login in same browser firstly logout user.
       if(Meteor.userId()){
         Meteor.call('logoutUser', Meteor.userId(), function(error, user) {
          Meteor.logout(function() {
            RocketChat.callbacks.run('afterLogoutCleanUp', user);
            return Meteor.call('logoutCleanUp', user);
          });
         });
       }
       // call loginWithEmailPassword to decrypt data params and get email and password
       Meteor.call('loginWithEmailPassword', context.queryParams, function(error, result) {
        if (result.email != null) {
          //call meteor loginWithPassword to lgoin into chat application.
          Meteor.loginWithPassword(result.email, result.password, function(error) {

            if (result.chatWithEmail != null) {
              FlowRouter.go('/direct/' + result.chatWithEmail);
            } else {
              FlowRouter.go('home');
            }
          });
        } else {
          FlowRouter.go('home');
        }
      });
    } else {
      BlazeLayout.render('main', {
        modal: RocketChat.Layout.isEmbedded(),
        center: 'loading'
      });
      if (!Meteor.userId()) {
        FlowRouter.go('home');
      }
      Tracker.autorun(function(c) {
        if (FlowRouter.subsReady() === true) {
          Meteor.defer(function() {
            var room;
            if (Meteor.user()) {
              if(Meteor.user().defaultRoom){
                room = Meteor.user().defaultRoom.split('/');
                FlowRouter.go(room[0], {
                  name: room[1]
                });
              }
            } else {
              FlowRouter.go('home');
            }
          });
          c.stop();
        }
      });
    }
  }
});

FlowRouter.route('/login', {
  name: 'login',
  action: function() {
    FlowRouter.go('home');
  }
});

FlowRouter.route('/home', {
  name: 'home',
  action: function(params, queryParams) {
    var context;
    //Get context object from current url.
    context = FlowRouter.current();
    // check context having data query params.
    if (context.queryParams.hasOwnProperty('data')) {
      Meteor.call('loginWithEmailPassword', context.queryParams, function(error, result) {
        if (result != null) {
          //call meteor loginWithPassword to lgoin into chat application.
          Meteor.loginWithPassword(result.email, result.password, function(error) {
            if (result.chatWithEmail != null) {
              FlowRouter.go('/direct/' + result.chatWithEmail);
            } else {
              FlowRouter.go('home');
            }
          });
        }
      });
    } else {
      if (Meteor.isClient) {
        Deps.autorun(function() {
          var cookieName;
          // check ServerCookies is ready
          if (ServerCookies.ready()) {
            cookieName = Meteor.settings['public'].cookieName;
            // call  getCookieByName method to cookie from browser localstorage by cookie name
            Meteor.call('getCookieByName', cookieName, function(err, result) {
              // if cookie is available then get email from cookie
              if (result != null) {
                //call getEmailByCookie to get email from cookie
                Meteor.call('getEmailByCookie', result, function(err, email) {
                  //call meteor owinLogin method to login into chat application.
                  Meteor.owinLogin(email, function(error) {});
                });
              }
            });
          }
        });
      }
    }
    KonchatNotification.getDesktopPermission();
    if (queryParams.saml_idp_credentialToken !== undefined) {
      Accounts.callLoginMethod({
        methodArguments: [{
          saml: true,
          credentialToken: queryParams.saml_idp_credentialToken
        }],
        userCallback: function() { BlazeLayout.render('main', {center: 'home'}); }
      });
    } else {
      BlazeLayout.render('main', {center: 'home'});
    }
    // RocketChat.TabBar.showGroup('home');
    // BlazeLayout.render('main', {
    //   center: 'home'
    // });
    KonchatNotification.getDesktopPermission();
  }
});

FlowRouter.route('/changeavatar', {
	name: 'changeAvatar',

	action() {
		RocketChat.TabBar.showGroup('changeavatar');
		BlazeLayout.render('main', {center: 'avatarPrompt'});
	}
});

FlowRouter.route('/account/:group?', {
	name: 'account',

	action(params) {
		if (!params.group) {
			params.group = 'Preferences';
		}
		params.group = _.capitalize(params.group, true);
		RocketChat.TabBar.showGroup('account');
		BlazeLayout.render('main', { center: `account${params.group}` });
	}
});

FlowRouter.route('/history/private', {
	name: 'privateHistory',

	subscriptions(/*params, queryParams*/) {
		this.register('privateHistory', Meteor.subscribe('privateHistory'));
	},

	action() {
		Session.setDefault('historyFilter', '');
		RocketChat.TabBar.showGroup('private-history');
		BlazeLayout.render('main', {center: 'privateHistory'});
	}
});

FlowRouter.route('/terms-of-service', {
	name: 'terms-of-service',

	action() {
		Session.set('cmsPage', 'Layout_Terms_of_Service');
		BlazeLayout.render('cmsPage');
	}
});

FlowRouter.route('/privacy-policy', {
	name: 'privacy-policy',

	action() {
		Session.set('cmsPage', 'Layout_Privacy_Policy');
		BlazeLayout.render('cmsPage');
	}
});

FlowRouter.route('/room-not-found/:type/:name', {
	name: 'room-not-found',

	action(params) {
		Session.set('roomNotFound', {type: params.type, name: params.name});
		BlazeLayout.render('main', {center: 'roomNotFound'});
	}
});

FlowRouter.route('/fxos', {
	name: 'firefox-os-install',

	action() {
		BlazeLayout.render('fxOsInstallPrompt');
	}
});

FlowRouter.route('/register/:hash', {
	name: 'register-secret-url',

	action(/*params*/) {
		BlazeLayout.render('secretURL');

		// if RocketChat.settings.get('Accounts_RegistrationForm') is 'Secret URL'
		// 	Meteor.call 'checkRegistrationSecretURL', params.hash, (err, success) ->
		// 		if success
		// 			Session.set 'loginDefaultState', 'register'
		// 			BlazeLayout.render 'main', {center: 'home'}
		// 			KonchatNotification.getDesktopPermission()
		// 		else
		// 			BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }
		// else
		// 	BlazeLayout.render 'logoLayout', { render: 'invalidSecretURL' }
	}
});
