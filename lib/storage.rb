require 'yaml'
require 'colorize'
require_relative 'job_posting'

class Storage
  attr_reader :matches

  def initialize
    @matches = YAML.load(File.read('./storage/matches.yml'))
    @misses = YAML.load(File.read('./storage/misses.yml'))
    @matches = [] unless @matches.is_a?(Array)
    @misses = [] unless @misses.is_a?(Array)
  end

  def save_match(job_posting)
    @matches << job_posting unless already_saved?(job_posting)
    File.open('./storage/matches.yml', 'w') { |f| f.write(@matches.to_yaml) }
  end

  def save_miss(job_posting)
    @misses << job_posting unless already_saved?(job_posting)
    File.open('./storage/misses.yml', 'w') { |f| f.write(@misses.to_yaml) }
  end

  def already_saved?(id)
    @misses.any? { |job| job.id == id } || @matches.any? { |job| job.id == id }
  end

  def save
    File.open('./storage/matches.yml', 'w') { |f| f.write(@matches.to_yaml) }
    File.open('./storage/misses.yml', 'w') { |f| f.write(@misses.to_yaml) }
  end

  def move_from_matches_to_misses(job_posting)
    deleted = @matches.reject! { |posting| posting == job_posting }
    raise 'Failed to delete match' unless deleted
    @misses << job_posting
  end
end