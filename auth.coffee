config = require './config.coffee'

everyauth = module.exports = require 'everyauth'
everyauth.debug = false
everyauth.everymodule.moduleErrback (err) ->
	console.log "Auth ERROR - "+err
	
everyauth.everymodule.findUserById (userId, callback) ->
	callback null, "moo"
	# callback has the signature, function (err, user) {...}
	
everyauth.twitter
    .consumerKey(config.twitterConsumerKey)
    .consumerSecret(config.twitterConsumerSecret)
    .findOrCreateUser((session, token, secret, user) ->
        promise = @.Promise().fulfill user
    ).redirectPath '/'