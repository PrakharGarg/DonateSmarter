require 'HTTParty'
require 'Nokogiri'
require 'JSON'
require 'Pry'
require 'csv'

page = HTTParty.get('http://austin.craigslist.org/search/pet?s=0')

parse_page = Nokogiri::HTML(page)

bikes_array = []

Pry.start(binding)
