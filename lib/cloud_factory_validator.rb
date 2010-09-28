require 'csv'
require 'roo'
require 'active_support/core_ext/object/blank'
require 'generic_spreadsheet'

# INPUT_HEADERS = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
#   :value => "Sprout", :required => true, :validation_format => "general"
#   },
#   {:field_id => "field_2", :label => "email", :field_type => "text_data",
#     :value => "spt@lala.com", :required => false, :validation_format => "email"
#     }]

    # Check the following keys
    # :label, :required, :validation_format

# Image Data
# 
# INPUT_HEADERS = [{:field_id => "field_1", :label => "Card title", :field_type => "image_data", 
#   :value => "Sprout contact card", :required => true, :validation_format => "url", :url => "http://myurl.com/image1.jpg", :alt => "Card title"
#   }]

class CloudFactoryValidator

  attr_accessor :errors, :rules
  attr_reader :return_value
  
  def initialize(rules)
    @errors = []
    @rules = rules
    @invalid_units, @temp_units, @valid_units = [], [], []
  end

  # returns true unless value is blank when required rule is true
  def required(rule, value)
    if rule && value.blank?
      false
    else
      true
    end
  end
  
  def valid(format, value)
    case format
      when "email"
        regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      when "url"
        regex = /^(http:\/\/|https:\/\/)?(www.)?[a-zA-Z0-9\-\.]+\.([a-zA-Z]{2,3})([.]?[a-zA-Z]{2})?(\/\S*)?$/i
        msg = "Start with http:// or https://"
      when "number"
        regex = /^\d{1,3}(\,?\d{3})*$/
      when "date"
        # Check if date (dd.mm.yyyy) is valid date or not
        #regex = /\d{1,2}(\/|-|\.|\s)\d{1,2}(\/|-|\.|\s)\d{2,4}/
        test = check_date(value)
        return test
      when "time"
        regex = /^(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
      # when "currency"
      when "general"
        return true
      else
        puts "Invalid format:: #{format}"
        return false
    end

    if !@invalid_units.include?(value) && !value.nil?
      if value.match(regex).nil?
        # puts "#{value} does not look like #{format}. #{msg if msg}"
        # puts "#{value} is not validated as #{format} by regex #{regex}."
        return false
      else
        return true
      end
    else
        return true
    end
  end
  
  def check_date(value)
    begin
      val = value.scan(/^(\d{1,2})[\/|-|\.|\s](\d{1,2})[\/|-|\.|\s](\d{2,4})$/) # dd.mm.yyyy
      Date.civil(val[0][2].to_i,val[0][1].to_i,val[0][0].to_i)
      !val.blank? ? true : false
    rescue
      # puts "Invalid Date:: #{value} is not valid date."
      return false
    end
  end
  
  # returns a hash of arrays with two keys :valid_units and :invalid_units
  # {:valid_units => @valid_units, :invalid_units => @invalid_units}
  def parse_and_validate(inputs)
    csv_contents = CSV.parse(inputs)
    csv_header = csv_contents[0].map{|a| a.strip unless a.nil? }

    # Initialize ih_labels array and store labels of INPUT_HEADERS into it
    ih_labels = Array.new
    rules.each do |rule|
      ih_labels << rule[:label]
    end
    
    if csv_header == ih_labels
      csv_contents[1..-1].each do |item|
        # Validation.
        rules.each_with_index do |header, index|
          next unless item # Escape nil items. This may result while reading csv file with blank line
          
          item[index].strip! if !item[index].nil?
          
          unless item.compact.empty?
            if required(header[:required], item[index]) and valid(header[:validation_format], item[index])
              # temporarily store valid units into temp_units array
              unless @temp_units.include?(item)
                @temp_units << item
              end
            else
              # Note:: While validating input data, collect invalid row(data) and process the others. Display invalid data to
              # user later
              unless @invalid_units.include?(item)
                @invalid_units << item
              end
            end
          end
        end

        # Convert csv data to hash. ['id','company'], [1, 'Google'] => {'id' => 1, 'company' => 'Google'}
        # data = Hash[csv_header.zip(item.map{|a| a.strip })]

        # Add the unit as input data to the production run (which will in turn pass it on to the first station)
        #run.stations.first.units << Unit.new(data)
      end
    else
      @errors << "Headers doesnot math the column counts"
    end
    
    # calculate valid_units
    @valid_units = @temp_units - @invalid_units
    
    {:valid_units => @valid_units, :invalid_units => @invalid_units}
    # puts "INVALID UNITS::#{@invalid_units.inspect}"
    # puts "VALID UNITS::#{@valid_units.inspect}"
  end
end

# inputs = File.read("fixtures/gdoc.csv")

# inputs = Excel.new("fixtures/gdoc.xls").to_csv

# inputs = Excelx.new("fixtures/msExcel.xlsx").to_csv

# inputs = Openoffice.new("fixtures/gdoc.ods").to_csv

# run = CloudFactoryValidator.new
# 
# run.input_data(inputs)