require 'rake'

desc 'Bundle install and setup database'
task :setup do
  sh "bundle install"
  sh "psql -c 'DROP DATABASE IF EXISTS indeed_scrape;'"
  sh "psql -c 'CREATE DATABASE indeed_scrape;'"
  Dir['db/migrations/*.rb'].sort.each do |migration|
    ruby migration
  end
end