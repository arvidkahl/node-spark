everyauth = module.exports = require 'everyauth'
everyauth.debug = true
everyauth.everymodule.moduleErrback (err) ->
	console.log err
everyauth.twitter
    .consumerKey('umY6lNpuhh4B6I1BshJMLA')
    .consumerSecret('I4qEqVHgZM0LEVY61sE9w1tFW5lTATCxOy7CwaO0NA')
    .findOrCreateUser((session, token, secret, user) ->
        promise = @.Promise().fulfill user
    ).redirectPath '/'

#everyauth = module.exports = require 'everyauth'
#
#everyauth.twitter.consumerKey 'umY6lNpuhh4B6I1BshJMLA'
#everyauth.twitter.consumerSecret 'I4qEqVHgZM0LEVY61sE9w1tFW5lTATCxOy7CwaO0NA'
#everyauth.twitter.findOrCreateUser ( sess, accessToken, accessSecret, twitUser, reqres) ->
#	console.log twitUser.screen_name