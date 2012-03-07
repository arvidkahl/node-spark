config = require './config.coffee'

everyauth = module.exports = require 'everyauth'
everyauth.debug = true
everyauth.everymodule.moduleErrback (err) ->
	console.log "Auth ERROR - "+err
everyauth.twitter
    .consumerKey(config.twitterConsumerKey)
    .consumerSecret(config.twitterConsumerSecret)
    .findOrCreateUser((session, token, secret, user) ->
        promise = @.Promise().fulfill user
    ).redirectPath '/'