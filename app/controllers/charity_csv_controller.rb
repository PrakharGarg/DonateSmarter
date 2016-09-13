class CharityCsvController < ApplicationController
  # Use the devise gem to authenticate that a user is logged in
  before_action :authenticate_user!

  def index
  end
  
  # Let users download a csv for an inputted charity
  # Params: 
  #   :name 
  #     string that contains the charity's name
  def csv
    # If no name is entered, do nothing
    if params[:name].blank? 
      redirect_to root_path
      return 0
    end
    # Append the charity's name to the name of the CSV
    filename = params[:name] +  "_Charities.csv"
    
    # Streaming the result
    self.response.headers["Content-Type"] ||= 'text/csv'
    self.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
    self.response.headers["Content-Transfer-Encoding"] = "binary"
    self.response.headers["Last-Modified"] = Time.now.ctime.to_s
    
    charity = Charity.find_by name: params[:name].upcase
    url = charity.url
    # Read the json from the S3 URL
    xml = open(url)
    charity_hash = Hash.from_xml(File.read(xml))
    field_names = []
    field_values = []
    recrusive_find_hash(charity_hash,field_names,field_values)
    
    self.response_body = Enumerator.new do |yielder|
      
      yielder << field_names.to_csv
      yielder << field_values.to_csv
    end
  end

  # Recursively find all of the headers and rows for the CSV by finding the 
  # bottom node for each hash.
  # Params:
  #   charity_hash
  #     Hash format of the JSON of the charity 
  #   field_names 
  #     Array that contains all of the headers for the CSV
  #   field_values 
  #     Array that contains all of the cell values for the CSV
  def recrusive_find_hash(charity_hash,field_names,values)
      charity_hash.each do |key,value|
        # If value is a hash, call the function again
        if value.is_a? Hash 
          recrusive_find_hash(value,field_names,values)
        else
          # If value is not a hash, key is the header and the value is the value
          field_names.push(key.to_s)
          values.push(value.to_s)
        end
      end
  end

end
