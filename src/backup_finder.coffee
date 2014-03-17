moment = require 'moment'
lazy = require 'lazy.js'
s3 = require './s3'

maxRequestCount = 10

module.exports =
  getMostRecentBackup: (bucket, prefix, before, callback) ->
    defaults = (options) ->
      lazy(options or {})
        .defaults(
          Bucket: bucket
          Prefix: prefix
        ).toObject()

    requestCount = 0
    handler = (err, objects) ->
      callback(err) if err?
      requestCount++

      # Results are alphabetical by Key, we might need to fetch another batch
      if objects?.IsTruncated
        marker = objects.NextMarker or objects.Contents[objects.Contents.length - 1].Key
        if requestCount > maxRequestCount
          callback new Error "Made over #{maxRequestCount} requests to S3, aborting"
        return s3.listObjects defaults(Marker: marker), handler

      object = lazy(objects?.Contents or [])
        .filter (object) ->
          moment(object.LastModified).isBefore before
        .max('LastModified')
      callback(new Error "Could not find any objects in bucket #{JSON.stringify(bucket)} with prefix #{JSON.stringify(prefix)} modified before #{moment(before).format('dddd, MMMM Do YYYY, h:mm:ss a ZZ')}") unless object?
      callback null, object

    s3.listObjects defaults(), handler
