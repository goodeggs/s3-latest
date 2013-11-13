fibrous = require 'fibrous'
lazy = require 'lazy.js'
progress = require 'progress'
through = require 'through'
optimist = require 'optimist'
bucket = optimist.argv.bucket

AWS = require 'aws-sdk'
s3 = new AWS.S3 apiVersion: '2006-03-01'

getMostRecentBackup = fibrous (bucket) ->
  lazy(s3.sync.listObjects(Bucket: bucket, Prefix: 'mongohq_backups/').Contents).max('LastModified')

(fibrous ->
  mostRecent = getMostRecentBackup.sync bucket
  s3.getObject(Bucket: bucket, Key: mostRecent.Key).createReadStream().pipe process.stdout
  return
) (err, response) ->
  throw err if err?
  console.log response if response?
