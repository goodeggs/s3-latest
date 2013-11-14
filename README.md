# s3-latest

A teeny tiny utility that retrieves the latest item in an Amazon S3 bucket.
Designed as a great way to get the most recent backup of something.
There are probably other uses.

Instructions:

1. Put `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in your `.profile`.
2. `npm install -g s3-latest`
3. `s3-latest --bucket bucketname | tar -xzv`
