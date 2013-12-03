finder = require './backup_finder'
through = require 'through'
s3 = require './s3'

module.exports = ({bucket, prefix, before}, callback) ->
  stream = through()
  finder.getMostRecentBackup bucket, prefix, before, (err, mostRecent) ->
    if err?
      callback(err) if callback?
      stream.emit 'error', err
      stream.end()

    stream[key] = value for key, value of mostRecent
    s3.getObject(Bucket: bucket, Key: mostRecent.Key).createReadStream().pipe stream
    callback(null, stream) if callback?
  stream
