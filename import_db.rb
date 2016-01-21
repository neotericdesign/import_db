#!/usr/bin/env ruby

# Simple script to pull remote Heroku postgres database to your local dev environment
# Author: Matthew Cowie
# www.neotericdesign.com

require 'optparse'

VERSION = '0.0.2'

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
    options[:tables] = t.split(',')
  end
end.parse!

options[:project] = ARGV[0]
options[:import_type] = '--clean'

abort "ERROR: You must specify a Heroku project" if options[:project].nil?

options[:database] ||= "#{options[:project]}_development"

if options[:refresh]
  `heroku pg:backups capture -a #{options[:project]}`
end

if options[:tables]
  options[:tables] = options[:tables].map { |t| "--table=#{t}" }.join(' ')
end

`curl -o latest.dump \`heroku pg:backups public-url -a #{options[:project]}\``
`pg_restore --verbose #{options[:import_type]} --no-acl --no-owner -h localhost #{options[:tables]} -d #{options[:database]} latest.dump`
`rm latest.dump`
