fibrous = require 'fibrous'
lazy = require 'lazy.js'
progress = require 'progress'
through = require 'through'

conf = require './conf'

AWS = require 'aws-sdk'
s3 = new AWS.S3 apiVersion: '2006-03-01'

getMostRecentBackup = fibrous (bucket) ->
  lazy(s3.sync.listObjects(Bucket: bucket, Prefix: 'mongohq_backups/').Contents).max('LastModified')

(fibrous ->
  mostRecent = getMostRecentBackup.sync conf.bucket
  s3.getObject(Bucket: conf.bucket, Key: mostRecent.Key).createReadStream().pipe process.stdout
  return
) (err, response) ->
  throw err if err?
  console.log response if response?
