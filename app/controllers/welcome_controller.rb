class WelcomeController < ApplicationController
  before_action :authenticate_user!
  autocomplete :charity, :name
  def index
  end
  
  def add_charities 
    parse_list = JSON.parse(open("https://s3.amazonaws.com/irs-form-990/index.json").read)
    # parse_list = JSON.parse(json)
    charity_list = parse_list["AllFilings"]
    charity_list.each do |charity|
      if (charity["IsAvailable"] == true && (Charity.exists?(name: charity["OrganizationName"]) == false))
          Charity.create(name: charity["OrganizationName"], url: charity["URL"])
      end
    end
  end 
  
end
