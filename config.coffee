convict = require 'convict'
path = require 'path'

conf = convict
  configFile:
    doc: "JSON config file that contains options for this program"
    format: "*"
    default: path.join process.env.HOME, '.config'
    env: "MONGORESTORE_CONFIG"
    arg: "config"
  accessKeyId:
    doc: "AWS Accesss Key Id"
    format: "*"
    default: null
    env: "AWS_ACCESS_KEY_ID"
    arg: "key_id"
  accessKeySecret:
