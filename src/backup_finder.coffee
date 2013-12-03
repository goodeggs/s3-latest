moment = require 'moment'
lazy = require 'lazy.js'
s3 = require './s3'

module.exports =
  getMostRecentBackup: (bucket, prefix, before, callback) ->
    s3.listObjects Bucket: bucket, Prefix: prefix, (err, objects) ->
      callback(err) if err?
      object = lazy(objects?.Contents or [])
        .filter (object) ->
          moment(object.LastModified).isBefore before
        .max('LastModified')
      callback(new Error "Could not find any objects in bucket #{JSON.stringify(bucket)} with prefix #{JSON.stringify(prefix)} modified before #{moment(before).format('dddd, MMMM Do YYYY, h:mm:ss a ZZ')}") unless object?
      callback null, object
