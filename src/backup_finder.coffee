fibrous = require 'fibrous'
lazy = require 'lazy.js'
s3 = require './s3'

module.exports =
  getMostRecentBackup: fibrous (bucket, prefix) ->
    lazy(s3.sync.listObjects(Bucket: bucket, Prefix: prefix).Contents).max('LastModified')
