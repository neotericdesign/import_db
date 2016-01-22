# import_db
Simple postgres database import script for Heroku projects
from your pals at [Neoteric Design](http://www.neotericdesign.com)

Current Version: 0.1.0

## Getting Started

Clone repo

`git clone git@github.com:neotericdesign/import_db.git`

Grant execute privilege

`chmod +x import_db/import_db.rb`

(Optional, recommended) Symlink the script in your home for easy access

`ln -s import_db/import_db.rb ~/import_db`

## Usage

`~/import_db your-heroku-app-name [options]`

### Options

`-d, --database [DATABASE]`

- Specifies local database to dump to
- Default: `yourherokuappname_development`

`-l, --live`

- Use a live dump of the data, rather than the latest pg:backup

`-t, --tables [TABLES]`

- Specify which tables to be included in dump.
- Note: This automatically sets `--live` because it's most reliably done with a
fresh pg_dump

` -v, --version`

- Returns script version 😬


