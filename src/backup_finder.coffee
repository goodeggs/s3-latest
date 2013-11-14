lazy = require 'lazy.js'
s3 = require './s3'

module.exports =
  getMostRecentBackup: (bucket, prefix, callback) ->
    s3.listObjects Bucket: bucket, Prefix: prefix, (err, objects) ->
      callback err, lazy(objects?.Contents or []).max('LastModified')
