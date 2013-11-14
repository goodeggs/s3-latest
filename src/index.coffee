fibrous = require 'fibrous'
progress = require 'progress'
through = require 'through'

conf = require './conf'
finder = require './backup_finder'
s3 = require './s3'

(fibrous ->
  mostRecent = finder.getMostRecentBackup.sync conf.bucket
  s3.getObject(Bucket: conf.bucket, Key: mostRecent.Key).createReadStream().pipe process.stdout
  return
) (err, response) ->
  throw err if err?
  console.log response if response?
