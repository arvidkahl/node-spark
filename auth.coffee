config = require './config.coffee'
User = require('./user.coffee').User
users = new User config.mainDBHost, config.mainDBPort, 'spark-user'

everyauth = module.exports = require 'everyauth'
everyauth.debug = false
everyauth.everymodule.moduleErrback (err) ->
	console.log "Auth ERROR - "+err
	
everyauth.everymodule.findUserById (userId, callback) ->  
	users.findById userId, (err,res) ->
		if res.id
			callback null, res
		else
			users.saveById JSON.stringify(userId), {"name":"test"}, (saveErr, saveRes) ->
				callback null, saveRes
	
everyauth.twitter
    .consumerKey(config.twitterConsumerKey)
    .consumerSecret(config.twitterConsumerSecret)
    .findOrCreateUser((session, token, secret, user) ->
      promise = @.Promise().fulfill user
    ).redirectPath '/'