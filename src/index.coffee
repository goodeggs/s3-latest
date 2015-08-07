finder = require './backup_finder'
s3 = require './s3'

module.exports =
  stream: ({bucket, prefix, before, glob}, callback) ->
    stream = require('through')()
    finder.getMostRecentBackup bucket, prefix, before, glob, (err, mostRecent) ->
      if err?
        callback(err) if callback?
        stream.emit 'error', err
        stream.end()

      stream[key] = value for key, value of mostRecent
      s3.getObject(Bucket: bucket, Key: mostRecent.Key).createReadStream().pipe stream
      callback(null, stream) if callback?
    stream

  downloadUrl: ({bucket, prefix, before, glob}, callback) ->
    finder.getMostRecentBackup bucket, prefix, before, glob, (err, mostRecent) ->
      callback(err) if err?
      s3.getSignedUrl 'getObject', {Bucket: bucket, Key: mostRecent.Key}, (err, url) ->
        mostRecent.signedUrl = url
        callback(null, mostRecent) if callback?
