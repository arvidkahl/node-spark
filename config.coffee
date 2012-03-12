config = {}

config.appPort = process.env.port || process.env.SPARK_APPPORT
config.mainDBPort = process.env.SPARK_MAINDBPORT || 5984
config.sessionDBHost = config.mainDBHost = process.env.SPARK_MAINDBHOST || 'localhost'
config.sessionDBUser = config.mainDBUser = process.env.SPARK_MAINDBUSER || 'username'
config.sessionDBPass = config.mainDBPass = process.env.SPARK_MAINDBPASS || 'password'

config.mainDB = process.env.SPARK_MAINDB || 'database_main'
config.sessionDBName = process.env.SPARK_SESSIONDBNAME || 'database_sessions'
config.twitterConsumerKey = process.env.SPARK_TWITTERCONSUMERKEY || 'twitterconsumerkey'
config.twitterConsumerSecret = process.env.SPARK_TWITTERCONSUMERSECRET || 'twitterconsumersecret'

module.exports = config