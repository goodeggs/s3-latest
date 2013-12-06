# s3-latest

[![NPM](https://nodei.co/npm/s3-latest.png)](https://nodei.co/npm/s3-latest/)

A teeny tiny utility that retrieves the latest item in an Amazon S3 bucket.
Designed as a great way to get the most recent backup of something.
There are probably other uses.

## Using from the command line

1. Put `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in your environment.
2. `npm install -g s3-latest`
3. `s3-latest --bucket bucketname --before 2013-12-12 | tar -xzv`

## Using from node.js

```javascript
var S3Latest = require('s3-latest');
var configuration = {
  bucket: 'bucketName',
  before: new Date("Mon, 02 Dec 2013 00:00:00 GMT")
}

// option 1:
S3Latest(configuration).pipe(process.stdout);

// option 2:
S3Latest(configuration, function(err, backup) {
  var fs = require('fs');
  if(err) return console.error(err.toString());
  backup.pipe(fs.createWriteStream(backup.Key));
});

```

## Options

These can be passed in as command line options or as keys to the configuration object.

- `--bucket`: S3 bucket name
- `--prefix`: String to search for files with. Needs to be at the beginning of the key. Usually used for s3 folder names.
- `--before`: A date (or a [`moment.js`-compatible string representation of a date](http://momentjs.com/docs/#/parsing/string/)). Returns the latest object in the bucket after this date.

## S3 Object details

When using the api with option 2 (see above), you can access the following information about the latest S3 object: 

- `Owner`: `{ID: '<< AWS IAM User id>>', DisplayName: '<< AWS IAM Display Name >>'}`
- `Size`: size of the object in bytes
- `ETag`: version information
- `LastModified`: timestamp
- `Key`: S3 Key
