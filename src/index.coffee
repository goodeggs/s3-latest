fibrous = require 'fibrous'

conf = require './conf'
finder = require './backup_finder'
s3 = require './s3'

(fibrous ->
  mostRecent = finder.getMostRecentBackup.sync conf.get('bucket'), conf.get('prefix')
  s3.getObject(Bucket: conf.get('bucket'), Key: mostRecent.Key).createReadStream().pipe process.stdout
  return
) (err, response) ->
  throw err if err?
  console.log response if response?
