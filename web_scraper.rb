require 'rubygems'
require 'mechanize'
require 'pdf-reader'
require 'open-uri'

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

# Create a new agent
agent = Mechanize.new
# Get the base page
base_page  = agent.get('http://foundationcenter.org/findfunders/990finder/')
# Check the Form 990 only option
base_page.form.radiobuttons_with(:name => '990_type')[1].checked
# Get the form
form_990_form = base_page.form()
# Input "Caring for Cambodia into the fn field"
form_990_form.fn = "Caring for Cambodia"
# Submit the form
base_page = agent.submit(form_990_form, form_990_form.buttons.first)

# Get the latest Form 990
pdf = base_page.link_with(:text => "Caring for Cambodia").click
# Open the pdf
io = open(pdf.uri.to_s)
reader = PDF::Reader.new(io)
# # Print out everything in the pdf
# reader.pages.each do |page|
#   puts page.text
# end

# Store the text in a string.
temp_store = ""
PDF::Reader.open(io) do |reader|
  reader.pages.each do |page|
    temp_store += page.text
  end
end
# print temp_store

# Create a Hash of stuff I actually want.
dict_of_stuff_I_care_about = Hash.new
# Split into an array of words
temp_store = temp_store.split
# Get Gross Receipts
gross_index = temp_store.index("Gross")
dict_of_stuff_I_care_about[:gross_receipts] = temp_store[gross_index+3]
# Get number of employees
employee_index = temp_store.index("employed") + 10
dict_of_stuff_I_care_about[:number_of_employees] = temp_store[employee_index]
# Get number of volunteers
volunteer_index = temp_store.index("volunteers")+4
dict_of_stuff_I_care_about[:number_of_volunteers] = temp_store[volunteer_index]
puts dict_of_stuff_I_care_about
