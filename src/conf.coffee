convict = require 'convict'
optimist = require 'optimist'

confSchema =
  bucket:
    doc: "The S3 bucket to download from"
    format: "*"
    default: null
    env: "AWS_S3_BUCKET"
    arg: "bucket"
  prefix:
    doc: "Filter items by names starting with this string"
    format: "*"
    default: ""
    env: "AWS_S3_PREFIX"
    arg: "prefix"
  access_key:
    doc: "Your AWS access key"
    env: "AWS_ACCESS_KEY"
    default: null
  secret:
    doc: "Your AWS access key secret"
    env: "AWS_SECRET_ACCESS_KEY"
    default: null

helpAndQuit = ->
  pkgInfo = require '../package.json'
  help = [ pkgInfo.description ]
  for key, val of confSchema
    line = "[env: #{val.env}] #{val.doc}"
    line = "--#{val.arg} #{line}" if val.arg?
    line = "#{line} (required)" unless val.default?
    help.push line
  console.log help.join '\n'
  process.exit 0

versionAndQuit = ->
  pkgInfo = require '../package.json'
  console.log "#{pkgInfo.name} #{pkgInfo.version}"
  process.exit 0

argv = optimist
  .alias
    help: 'h'
    version: 'v'
  .argv

helpAndQuit() if argv.help?
versionAndQuit() if argv.version?

module.exports = conf = convict(confSchema)
try
  conf.validate()
catch e
  helpAndQuit()

