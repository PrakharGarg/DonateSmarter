class CharityCsvController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  
  # Let users download a csv for a select charity. 
  # Param: 
  # => Charity Name that should be
  def csv
    if params[:name].blank? 
      redirect_to root_path
      return 0
    end
    filename = params[:name] +  "_Charities.csv"
  
    # Streaming the result
    self.response.headers["Content-Type"] ||= 'text/csv'
    self.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
    self.response.headers["Content-Transfer-Encoding"] = "binary"
    self.response.headers["Last-Modified"] = Time.now.ctime.to_s
    charity = Charity.find_by name: params[:name].upcase
    url = charity.url
    xml = open(url)
    a = Hash.from_xml(File.read(xml))
    field_names = []
    field_values = []
    recrusive_find_hash(a,field_names,field_values)
    
    self.response_body = Enumerator.new do |yielder|
      
      yielder << field_names.to_csv
      yielder << field_values.to_csv
      
    end
end

def recrusive_find_hash(hash,field_names,values)
    hash.each do |key,value|
      if value.is_a? Hash 
        recrusive_find_hash(value,field_names,values)
      else
        field_names.push(key.to_s)
        values.push(value.to_s)
      end
    end
end
  
end
