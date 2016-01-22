#!/usr/bin/env ruby

# Simple script to pull remote Heroku postgres database to your local dev environment
# Author: Matthew Cowie
# www.neotericdesign.com

require 'optparse'

VERSION = '0.0.3'

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

  opts.on("-t", "--tables [TABLES]", "Specify tables, comma separated") do |t|
    options[:tables] = t.split(',').map { |table| "--table=#{table}" }.join(' ')
  end
end.parse!

options[:project] = ARGV[0]
options[:import_type] = '--clean'

abort "ERROR: You must specify a Heroku project" if options[:project].nil?

options[:database] ||= "#{options[:project]}_development"

if options[:refresh] || options[:tables]
  connection_string = `heroku pg:credentials DATABASE --app #{options[:project]}`[/Connection info string:.*\"(.*)\"/m, 1]
  puts "Dumping remote database..."
  `pg_dump -Fc -f latest.dump "#{connection_string}" #{options[:tables]}`
else
  puts "Grabbing last backup..."
  `curl -o latest.dump \`heroku pg:backups public-url -a #{options[:project]}\``
end

`pg_restore --verbose #{options[:import_type]} --no-acl --no-owner -h localhost -d #{options[:database]} latest.dump`
`rm latest.dump`
