# MediaWiki with VisualEditor and Maps Plugins

This container serves a MediaWiki with VisualEditor an Maps plugins.

## Usage

This image provides a full MediaWiki, but it is indented for use with
`docker-compose` since some plugins require additional services.

### Initial setup

First, run the container with a the example `docker-compose.yml`
below. Replace `/path/to/persistance` with your persistance path.

```
version: '3'
services:
  mediawiki:
    image: timrichardt/mediawiki-extended:latest
    ports:
      - 7000:80
    volumes:
      # - /path/to/persistence/LocalSettings.php:/var/www/html/LocalSettings.php
      - /path/to/persistence/images:/var/www/html/images
      - /path/to/persistence/data:/var/www/data
      # - /path/to/persistence/.htaccess:/var/www/html/.htaccess
      # - /path/to/persistence/favicon.ico:/var/www/html/favicon.ico

  parsoid:
    image: pastakhov/parsoid:latest
    environment:
      - PARSOID_DOMAIN_localhost=http://mydomain.com/api.php
```

Then run `docker-compose up` and walk through the MediaWiki setup.

After the setup, share the `LocalSettings.php` with MediaWiki by
putting in into your persisitence path and enabling the corresponding 
volume in the `docker-compose.yml`.

### Enable VisualEditor

To enable the VisualEditor plugin, append the following to your
`LocalSettings.php`

```php
wfLoadExtension( 'VisualEditor' );

// Enable by default for everybody
$wgDefaultUserOptions['visualeditor-enable'] = 1;

// Optional: Set VisualEditor as the default for anonymous users
// otherwise they will have to switch to VE
$wgDefaultUserOptions['visualeditor-editor'] = "visualeditor";

// Don't allow users to disable it
// $wgHiddenPrefs[] = 'visualeditor-enable';

// OPTIONAL: Enable VisualEditor's experimental code features
$wgDefaultUserOptions['visualeditor-enable-experimental'] = 1;

$wgVisualEditorParsoidURL = 'http://parsoid:8000';

$wgVirtualRestConfig['modules']['parsoid'] = array(
    // URL to the Parsoid instance
    // Use port 8142 if you use the Debian package
    'url' => 'http://parsoid:8000',
    // Parsoid "domain", see below (optional)
    'domain' => 'localhost',
    // Parsoid "prefix", see below (optional)
    'prefix' => 'localhost',
);


$wgVirtualRestConfig['modules']['parsoid']['forwardCookies'] = true;
```

Also ensure, that `mydomain.com` is replaced in the last line of
`docker-compose.yml` by the host the wiki can be reached on, e.g.

```
      - PARSOID_DOMAIN_localhost=http://de.wikipedia.org/w/api.php
```

For further information please consider
- [VisualEditor Documentation](https://www.mediawiki.org/wiki/Extension:VisualEditor)
- [pastakhov/parsoid Docker image](https://hub.docker.com/r/pastakhov/parsoid)

### Enable Maps
To enable the Maps plugin, append the following to your `LocalSettings.php`

```php
wfLoadExtension( 'Maps' );

require_once __DIR__ . '/extensions/Maps/Maps_Settings.php';
```

For further information please consider
- [Maps Documentation](https://www.mediawiki.org/wiki/Extension:Maps)

### Increase upload size

Create a `.htaccess` file with following contents and mount it as a volume
by uncommenting the corresponding line in `docker-compose.yml`

```
php_value upload_max_filesize 100M
php_value post_max_size 100M
```

### Add E-Mail Support

Replace the following lines with your account data and append it to
`LocalSettings.php`

```
$wgSMTP = [
 'host' => 'ssl://smtp.y.org',
 'IDHost' => y.org',
 'port' => 465,
 'username' => 'x@y.org',
 'password' => '***',
 'auth' => true
];
```


# License

MIT
