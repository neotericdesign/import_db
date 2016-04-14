# import_db
Simple postgres database import script for Heroku projects
from your pals at [Neoteric Design](http://www.neotericdesign.com)

Current Version: 0.1.0

## Requirements

Just Ruby 😬

## Getting Started

Clone repo

`git clone git@github.com:neotericdesign/import_db.git`

Grant execute privilege

`chmod +x import_db/import_db.rb`

(Optional, recommended) Symlink the script for easy access, e.g:

`ln -s import_db/import_db.rb /usr/bin/local/import_db`

## Usage

`import_db [heroku-app-name] [options]`

### Options

`heroku-app-name`
- Specify the heroku app to pull from. Only supports the default postgres
database you have set.
- Default: the current directory name. If unset will prompt you before taking
action.

`-d, --database [DATABASE]`

- Specifies local database to dump to
- Default: `herokuappname_development`

`-l, --live`

- Use a live dump of the data, rather than the latest pg:backup

`-t, --tables [TABLES]`

- Specify which tables to be included in dump.
- Note: This automatically sets `--live` because it's most reliably done with a
fresh pg_dump

` -v, --version`

- Returns script version 😬


