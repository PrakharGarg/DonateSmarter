class WelcomeController < ApplicationController
  # Use the devise gem to authenticate that a user is signed in before the page
  # renders. 
  before_action :authenticate_user!
  # Use the autocomplete gem to autocomplete the charity search
  autocomplete :charity, :name

  def index
  end
  
  # THIS SHOULD NOT BE RUN. This is a nuke. Takes about 3 days to run and 
  # parse all of the charities into the database. #TODO add a tax year date
  # to the database so I know I have the most recent data. 
  # def add_charities 
  #   json = File.read("./charity_list.json")
  #   parse_list = JSON.parse(json)
  #   # parse_list = JSON.parse(json)
  #   charity_list = parse_list["AllFilings"]
  #   charity_list.each do |charity|
  #     if (charity["IsAvailable"] == true && (Charity.exists?(name: charity["OrganizationName"]) == false))
  #         Charity.create(name: charity["OrganizationName"], url: charity["URL"])
  #     end
  #   end
  # end 
  
end
