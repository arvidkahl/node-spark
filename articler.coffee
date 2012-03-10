# Articler Class - Handles all article functions
config = require './config.coffee'
cradle = require 'cradle'
 
class Articler
    constructor: (host, port, collection) ->
        @.connect = new cradle.Connection host, port, {
            cache: true
            raw: false
        }
        @.db = @.connect.database collection

    findAll: (callback) ->
        @.db.view 'sparks/all', {descending: true}, (err, res) ->
            if (err)
                callback err
            else
                docs = []
                res.forEach (row) ->
                    docs.push row
                callback null, docs

    findAllIds: (callback) ->
        @.db.view 'sparks/allbyid', {descending: true}, (err, res) ->
            if (err)
                callback err
            else
                ids = []
                res.forEach (row) ->
                    ids.push row
                callback null, ids

    findById: (mykey, callback) ->
	    @.db.view 'sparks/byid', {key: mykey}, (err, res) ->
		    if (err)
		        callback err
		    else 
		       callback null, res[0]
	
		  
    save: (articles, callback) ->
        @.db.save articles, (err, res) ->
            if (err)
                callback err
            else
                callback null, articles, res

    saveById: (id, articles, callback) ->
        @.db.save id, articles, (err, res) ->
            if (err)
                callback err
            else
                callback null, articles, res
 
exports.Articler = Articler