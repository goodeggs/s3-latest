finder = require './backup_finder'
through = require 'through'
s3 = require './s3'

module.exports = (bucket, prefix) ->
  stream = through()
  finder.getMostRecentBackup bucket, prefix, (err, mostRecent) ->
    if err?
      console.error err.toString()
      stream.end()
    s3.getObject(Bucket: bucket, Key: mostRecent.Key).createReadStream().pipe stream
  stream
