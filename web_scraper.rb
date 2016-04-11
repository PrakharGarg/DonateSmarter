require 'rubygems'
require 'mechanize'

# # Instatiate a new mechanize object
# agent = Mechanize.new
# # # Use the agent to fetch a page
# page = agent.get('http://google.com/')
# # List all of the links on the homepage
# # page.links.each do |link|
# #   puts link.text
# # end
#
# # Fetch the form off the page
# google_form = page.form('f')
# # Access the input field 'q' and put in 'ruby mechanize'
# # google_form.q = 'ruby mechanize'
# # # Submit the form
# # page = agent.submit(google_form,google_form.buttons.first)
#
# pp page

##########Scraping Data##########

agent = Mechanize.new
base_page  = agent.get('http://foundationcenter.org/findfunders/990finder/')

base_page.form.radiobuttons_with(:name => '990_type')[1].checked

form_990_form = base_page.form()
form_990_form.fn = "Caring for Cambodia"

base_page = agent.submit(form_990_form, form_990_form.buttons.first)
pp base_page
