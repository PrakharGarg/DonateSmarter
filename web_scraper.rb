require 'rubygems'
require 'mechanize'

# Instatiate a new mechanize object
agent = Mechanize.new
# Use the agent to fetch a page
page = agent.get('http://google.com/')
# List all of the links on the homepage
# page.links.each do |link|
#   puts link.text
# end
