class FullReportsController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  
  
  def csv
    
    if params[:q].blank? || params[:s].blank?
      redirect_to full_csv_path
    end
      
    # Append the charity's name to the name of the CSV
    filename = params[:q] + "-" + params[:s] + "Charities.csv"
  
    # Streaming the result
    self.response.headers["Content-Type"] ||= 'text/csv'
    self.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
    self.response.headers["Content-Transfer-Encoding"] = "binary"
    self.response.headers["Last-Modified"] = Time.now.ctime.to_s
    
    i = 0
    x = 1
    # url = Charity.first.url
    # # Read the json from the S3 URL
    # xml = open(url)
    # if xml.is_a? StringIO
    #   xml = xml.string
    #   charity_hash = Hash.from_xml(xml)
    # else
    #   charity_hash = Hash.from_xml(File.read(xml))
    # end
    # field_names = []
    # field_values = []
    # recrusive_find_hash(charity_hash,field_names,field_values)
    self.response_body = Enumerator.new do |yielder|
      
      charities = Charity.where(:id => params[:q]..params[:s])
      charities.find_each(:batch_size => 100) do |charity|
        url = charity.url
        # Read the json from the S3 URL
        xml = open(url)
        if xml.is_a? StringIO
          xml = xml.string
          charity_hash = Hash.from_xml(xml)
        else
          charity_hash = Hash.from_xml(File.read(xml))
        end
        field_names = []
        field_values = []
        @counter = 0
        recursive_find_hash(charity_hash,field_names,field_values)
        
        yielder << field_names.to_csv
        yielder << field_values.to_csv
        if (i / 100) > x 
          binding.pry
          http = Net::HTTP.new('www.google.com',80)
          response = http.request_get('/')
          x +=1
        end
        i +=1
      end
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
  def recursive_find_hash(charity_hash,field_names,values)
      charity_hash.each do |key,value|
        # If value is a hash, call the function again
        if value.is_a? Hash 
          recursive_find_hash(value,field_names,values)
        elsif value.is_a? Array 
          if (value.first.is_a? Hash) == false
            if field_names.include? (key.to_s)
              key += @counter.to_s
              @counter += 1
            end
            field_names.push(key.to_s)
            values.push(value.to_s)
          else
            value.each do |array|
              recursive_find_hash(array, field_names, values)
            end  
          end
        else
        # If value is not a hash, key is the header and the value is the value
        if field_names.include? key.to_s
          key += @counter.to_s
          @counter += 1
        end
        field_names.push(key.to_s)
        values.push(value.to_s)
        end
      end
      
  end

end
  
