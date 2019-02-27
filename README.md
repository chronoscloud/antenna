[![Build Status](https://travis-ci.org/soulchild/antenna.svg?branch=master)](https://travis-ci.org/soulchild/antenna)

# Antenna

Antenna aims to take the pain out of creating and distributing all the necessary files for Enterprise iOS over-the-air distribution. It generates the mandatory XML manifest, app icons and an HTML file, automatically extracting all the needed information from the specified `.ipa` file, and uploads everything via a distribution method of your choice (currently only S3 and local filesystem are supported, but you're encouraged to create other storage backends). The result is a (signed S3) URL, which you may then send to your clients, so they can easily install your app from Mobile Safari with just one tap.

## Installation

```bash
gem install antenna-ota
```

## Usage

Antenna adds the `antenna` command to your PATH:

```bash
$ antenna

  Antenna

  Painless iOS over-the-air enterprise distribution

  Commands:
    help    Display global or [command] help documentation
    local   Distribute .ipa file to local file system
    s3      Distribute .ipa file over Amazon S3

  Global Options:
    --verbose
    -h, --help           Display help documentation
    -v, --version        Display version information
    -t, --trace          Display backtrace when an error occurs
```

### S3-specific options

```
    -f, --file FILE                             .ipa file to distribute
    -a, --access-key-id ACCESS_KEY_ID           S3 access key ID
    -s, --secret-access-key SECRET_ACCESS_KEY   S3 secret access key
    -b, --bucket BUCKET                         S3 bucket name
        --[no-]create                           (Don't) create bucket if it doesn't already exist
    -r  --region REGION                         AWS region (optional, e.g. https://mys3.example.com)
    -e  --endpoint ENDPOINT                     S3 endpoint (optional, e.g. https://mys3.example.com)
    -x  --expires EXPIRES                       Expiration of URLs in seconds (optional, e.g. 86400 = one day, one week max)
    -i  --base BASE                             Base filename (optional, defaults to IPA filename without .ipa extension)
    -p  --public                                Use public instead of signed URLs (you'll might want '--acl public-read' also)
        --acl ACL                               Permissions for uploaded files. Must be one of: private, public-read, public-read-write, authenticated-read, bucket-owner-read, bucket-owner-full-control (optional, defaults to private)
```

### Local-specific options

```
    -f, --file FILE      .ipa file to distribute (searches current directory for .ipa files if not specified)
    -U, --url URL        Base URL all files should be prefixed with
    -i, --base BASE      Base filename (optional, defaults to IPA filename without .ipa extension)
```

## Examples

### 1. Private, signed URL

Create a new S3 bucket called `antenna-ota` on Amazon's `eu-central-1` S3 cluster and upload OverTheAir.ipa, resulting in a signed URL for distribution:

```bash
$ antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file OverTheAir.ipa --region eu-central-1 --create --bucket antenna-ota
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://antenna-ota.s3.eu-central-1.amazonaws.com/OverTheAir.html?<...signing-parameters...>
```

### 2. Public, unsigned URL

Upload OverTheAir.ipa to Amazon's `eu-central-1` S3 cluster, resulting in a publically available, unsigned URL for distribution:

```bash
$ antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file OverTheAir.ipa --public --acl public-read --region eu-central-1 --bucket antenna-ota
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://antenna-ota.s3.eu-central-1.amazonaws.com/OverTheAir.html
```

The resulting URLs show an installation page like the following and can be distributed to your users for installation. The meta-data and app-icon is automatically extracted from the given .ipa file:

![Installation site](https://raw.githubusercontent.com/soulchild/antenna/master/assets/example-installation.png)

_Note:_ App icons in any .ipa file are converted from PNG to [Apple's CgBI file format](http://iphonedevwiki.net/index.php/CgBI_file_format) and therefore not viewable in most applications, including Chrome and Firefox. Apple applications like (Mobile) Safari or Preview.app know how to handle the format though.

### 3. Local file system

Distribute OverTheAir.ipa to the local file-system. The resulting files can then be uploaded manually:

```bash
$ antenna local --url https://www.example.com/ipa/ --file OverTheAir.ipa
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://www.example.com/ipa/OverTheAir.html
```

## Author

Tobi Kremer ([soulchild](https://www.github.com/soulchild))

Inspired by Mattt Thompson's [iOS toolchain](https://github.com/nomad).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/soulchild/antenna).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
