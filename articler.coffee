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
 
    save: (articles, callback) ->
        @.db.save articles, (err, res) ->
            if (err)
                callback err
            else
                callback null, articles
 
exports.Articler = Articler