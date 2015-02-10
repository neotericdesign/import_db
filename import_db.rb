#!/usr/bin/env ruby

# Simple script to pull remote Heroku postgres database to your local dev environment
# Author: Matthew Cowie
# www.neotericdesign.com

require 'optparse'

VERSION = '0.0.1'

options = {}
OptionParser.new do |opts|
  opts.banner = "Import database from a Heroku project. Usage: import_db.rb project [options]"

  opts.on("-d", "--database [DATABASE]", "Specify the local database to import to") do |d|
    options[:database] = d
  end

  opts.on("-r", "--refresh", "Refresh the backup with the latest data") do |r|
    options[:refresh] = r
  end

  opts.on("-v", "--version", "Show version") do
    puts VERSION
    exit
  end
end.parse!

options[:project] = ARGV[0]
abort "ERROR: You must specify a Heroku project" if options[:project].nil?

options[:database] ||= "#{options[:project]}_development"

if options[:refresh]
  `heroku pgbackups:capture --expire -a #{options[:project]}`
end

`curl -o latest.dump \`heroku pgbackups:url -a #{options[:project]}\``
`pg_restore --verbose --clean --no-acl --no-owner -h localhost -d #{options[:database]} latest.dump`
`rm latest.dump`