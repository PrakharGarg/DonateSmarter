class FullReportsController < ApplicationController
  before_action :authenticate_user!

  def index
  end
  
  def csv
    filename = "All_Charities.csv"
  
    # Streaming the result
    self.response.headers["Content-Type"] ||= 'text/csv'
    self.response.headers["Content-Disposition"] = "attachment; filename=#{filename}"
    self.response.headers["Content-Transfer-Encoding"] = "binary"
    self.response.headers["Last-Modified"] = Time.now.ctime.to_s
    
    
    
    self.response_body = Enumerator.new do |yielder|
      
      yielder << index_header_names().to_csv
      
      
      
      # fees.find_each(batch_size: 100) do |donation|
      #   if (donation.fee_name.include? "Champions")
      #     exhibitor_id = donation.exhibitor_id
      #     fee_name = donation.fee_name
      #     fee_quantity = donation.quantity
      #     fee_amount = "$" + (donation.fee_amount * fee_quantity).to_s 
      #     fee_created_at = donation.created_at
      #     exhibitor = Exhibitor.find(exhibitor_id)
      #     customer = exhibitor.customer
      #     data_row = [
      #       exhibitor.first_name,
      #       exhibitor.last_name,
      #       exhibitor.address,
      #       exhibitor.city,
      #       exhibitor.zip_code,
      #       customer.email,
      #       exhibitor.customer_id,
      #       fee_name,
      #       fee_quantity,
      #       fee_amount,
      #       fee_created_at
      #     ]
          
          # yielder << data_row.to_csv
          
        # end
      end
    end

  def index_header_names()
    field_names = %w(
    First_Name
    Last_Name
    Address
    City
    Zip_Code
    Email  
    Customer_Id
    Fee_Name
    Quantity
    Total_Donation
    Order_Date
    )
  end
end
