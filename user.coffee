# User Class - Handles all user functions
config = require './config.coffee'
cradle = require 'cradle'
 
class User
    constructor: (host, port, collection) ->
        @.connect = new cradle.Connection host, port, {
            secure: false
            auth: {
                username: config.mainDBUser
                password: config.mainDBPass 
            }
            cache: true
            raw: false
        }
        @.db = @.connect.database collection

    findById: (mykey, callback) ->
      @.db.view 'spark-user/byid', {key: JSON.stringify(mykey)}, (err, res) ->
        if (err)
            callback err, null
        else 
           if res.length>0
             callback null, res[0]
           else 
             callback null, res
    saveById: (id, data, callback) ->
      @.db.save id, data, (err, res) ->
        callback 	err, res	

exports.User = User