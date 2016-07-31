class WelcomeController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  
  def add_charities 
      # binding.pry
      # a = JSON.parse(open("https://s3.amazonaws.com/irs-form-990/index.json").read)
      # b = 0
      # url = 'https://s3.amazonaws.com/irs-form-990/index.json'
      # response = Net::HTTP.get_response(URI.parse(uri))
      # data = response.body
      # giant_list = JSON.parse(data)
      # binding.pry
      # giant_list.first.each do |chairty|
      #   if (Charity.exists?(name: charity["OrganizationName"]) == false)
      #     Charity.create(name: charity["OrganizationName"], url: charity["URL"])
      #   end
      # end
      
      json = File.read("./charity_list.json")
      parse_list = JSON.parse(json)
      charity_list = parse_list["AllFilings"]
      binding.pry
      charity_list.each do |charity|
        if (charity["IsAvailable"] == true && (Charity.exists?(name: charity["OrganizationName"]) == false))
            Charity.create(name: charity["OrganizationName"], url: charity["URL"])
        end
      end
  end 
end
