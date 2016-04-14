#!/usr/bin/env ruby

# Simple script to pull remote Heroku postgres database to your local dev environment
# Author: Matthew Cowie
# www.neotericdesign.com

require 'optparse'

VERSION = '0.1.0'
WORKING_DIR = File.basename(Dir.getwd)

def ask_yn(question, default = :y)
  option_y = :y == default ? 'Y' : 'y'
  option_n = :n == default ? 'N' : 'n'

  puts "#{question} (#{option_y}/#{option_n})"
  response = STDIN.gets.chomp

  if response.nil?
    response = default
  else
    response = response.downcase.chr.to_sym
  end

  response == :y
end

options = {}
OptionParser.new do |opts|
  opts.banner = "Import database from a Heroku project. Usage: import_db.rb project [options]"

  opts.on("-d", "--database [DATABASE]", "Specify the local database to import to") do |d|
    options[:database] = d
  end

  opts.on("-l", "--live", "Source from live database instead of latest backup") do |l|
    options[:live] = l
  end

  opts.on("-t", "--tables [TABLES]", "Specify tables, comma separated") do |t|
    options[:tables] = t.split(',').map { |table| "--table=#{table}" }.join(' ')
    options[:live] = true
  end

  opts.on("-v", "--version", "Show version") do
    puts VERSION
    exit
  end
end.parse!


options[:project] = ARGV[0]
no_project_specified = options[:project].nil?
options[:project] ||= WORKING_DIR
options[:import_type] = '--clean'
options[:database] ||= "#{options[:project]}_development"


if no_project_specified
  unless ask_yn("Import database of '#{options[:project]}' to local database '#{options[:database]}'?")
    abort
  end
end


if options[:refresh]
  connection_info = `heroku pg:credentials DATABASE --app #{options[:project]}`[/Connection info string:.*\"(.*)\"/m, 1]
  puts "Dumping remote database..."
  `pg_dump -Fc -f latest.dump "#{connection_info}" #{options[:tables]}`
else
  puts "Grabbing last backup..."
  `curl -o latest.dump \`heroku pg:backups public-url -a #{options[:project]}\``
end

`pg_restore --verbose #{options[:import_type]} --no-acl --no-owner -h localhost -d #{options[:database]} latest.dump`
`rm latest.dump`
