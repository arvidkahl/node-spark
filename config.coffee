config = {}

config.appPort = process.env.PORT || process.env.port || 5000 || process.env.SPARK_APPPORT
config.mainDBPort = process.env.SPARK_MAINDBPORT || 5984
config.sessionDBHost = config.mainDBHost = process.env.SPARK_MAINDBHOST || 'localhost'
config.sessionDBUser = config.mainDBUser = process.env.SPARK_MAINDBUSER || 'username'
config.sessionDBPass = config.mainDBPass = process.env.SPARK_MAINDBPASS || 'password'

config.mainDB = process.env.SPARK_MAINDB || 'database_main'
config.sessionDBName = process.env.SPARK_SESSIONDBNAME || 'database_sessions'
config.twitterConsumerKey = process.env.SPARK_TWITTERCONSUMERKEY || 'twitterconsumerkey'
config.twitterConsumerSecret = process.env.SPARK_TWITTERCONSUMERSECRET || 'twitterconsumersecret'

module.exports = config

# views for the user database
#       "all": {
#           "map": "function(doc) {  emit(doc._id, doc);}"
#       },
#       "byid": {
#           "map": "function(doc) {if(doc._id) emit(doc._id,doc); }"
#       },
#       "byTwitterId": {
#           "map": "function(doc) {if(doc.twitter.id) emit(doc._id,doc); }"
#
# view for scene database
#       "all": {
#           "map": "function(doc) {\n  emit(null, doc);\n}"
#       },
#       "byid": {
#           "map": "function(doc) {if(doc._id){emit(doc._id, doc);}}"
#       },
#       "allbyid": {
#           "map": "function(doc) {if(doc.url){emit(doc._id, null);}}"
