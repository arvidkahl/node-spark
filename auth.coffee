everyauth = module.exports = require 'everyauth'
everyauth.debug = false
everyauth.everymodule.moduleErrback (err) ->
	console.log err
everyauth.twitter
    .consumerKey('umY6lNpuhh4B6I1BshJMLA')
    .consumerSecret('I4qEqVHgZM0LEVY61sE9w1tFW5lTATCxOy7CwaO0NA')
    .findOrCreateUser((session, token, secret, user) ->
        promise = @.Promise().fulfill user
    ).redirectPath '/'