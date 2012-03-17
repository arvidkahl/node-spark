config = require './config.coffee'
User = require('./user.coffee').User
users = new User config.mainDBHost, config.mainDBPort, 'spark-user'

everyauth = module.exports = require 'everyauth'
everyauth.debug = false
everyauth.everymodule.moduleErrback (err) ->
	console.log "Auth ERROR - "+err
	
everyauth.everymodule.findUserById (userId, callback) ->  
	users.findByTwitterId userId, (err,res) ->
		if res.id
			callback null, res.value
		else
			callback null, null
	
everyauth.twitter
    .consumerKey(config.twitterConsumerKey)
    .consumerSecret(config.twitterConsumerSecret)
    .findOrCreateUser((session, token, secret, user) ->
      users.findByTwitterId user.id, (err,res) ->
        if res.id
          user=res.value
        else
          newUser = {id:user.id,name:user.name,twitter:user}
          user = newUser
          users.saveById JSON.stringify(user.id), user, (saveErr, saveRes) -> 
      promise = @.Promise().fulfill user
      
    ).redirectPath '/'