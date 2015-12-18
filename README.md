[![Stories in Ready](https://badge.waffle.io/mobileeventguide/ihazbucket.png?label=ready&title=Ready)](https://waffle.io/mobileeventguide/ihazbucket)
![ihazbucket](http://i0.kym-cdn.com/photos/images/original/000/000/026/lolrus.jpg)

# I Haz Bucket
A simple S3 management tool

---

## Development Setup

Install Ruby Gems
```
bundle install
```

Copy .env file and configure with AWS credentials, region and bucket.
```
cp .env.sample .env
```

Start the server with rackup
```
rackup -p 4567
```
