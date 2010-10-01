require 'csv'
require 'roo'
require 'active_support/core_ext/object/blank'
require 'generic_spreadsheet'

def required(rule, value)
  # returns true unless value is blank when required rule is true
  (rule && value.blank?) ? false : true
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

  if !value.nil? # && !@invalid_units.include?(value)
    value.match(regex).nil? ? false : true
    # puts "#{value} does not look like #{format}. #{msg if msg}"
    # puts "#{value} is not validated as #{format} by regex #{regex}."
  else
    return true
  end
end

def check_date(value)
  begin
    val = value.scan(/^(\d{1,2})[\/|-|\.|\s](\d{1,2})[\/|-|\.|\s](\d{2,4})$/) # dd.mm.yyyy
    Date.civil(val[0][2].to_i,val[0][1].to_i,val[0][0].to_i) # civil check julian date in yyyy.mm.dd
    !val.blank? ? true : false
  rescue
    # puts "Invalid Date:: #{value} is not valid date."
    return false
  end
end

class CFInputValidator

  attr_accessor :errors, :rules
  
  def initialize(rules)
    @errors = []
    @rules = rules
    @invalid_units, @temp_units, @valid_units = [], [], []
  end
  
  def self.check_extension(file_location)
    @error = []
    ext = File.extname(file_location).sub(/./,"")  
    formats = %w[csv xls xlsx ods]
    check = formats.include?(ext)
    
    @error << "Invalid file! The specified format is not supported." unless check
    {:check => check, :error => @error}
  end

  module ResultValidator
    def self.valid?(rules, result)
      # ...
      csv_contents = CSV.parse(result)
      csv_header = csv_contents[0].map{|a| a.strip unless a.nil? }
      
      ih_labels = Array.new
      rules.each do |rule|
        ih_labels << rule[:label]
      end
      
      if csv_header == ih_labels
        bool = true
        csv_contents[1..-1].each do |item|
          rules.each_with_index do |header, index|
            next unless item
            
            unless item.compact.empty?
              item[index].strip! if !item[index].nil?
              
              if required(header[:required], item[index]) and valid(header[:validation_format], item[index])
                bool = true
              else
                bool = false
              end
            end
            
          end
        end
        
      end
    else
      return bool
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
          
          unless item.compact.empty?
            item[index].strip! if !item[index].nil?
            
            if required(header[:required], item[index]) and valid(header[:validation_format], item[index])
              # temporarily store valid units into temp_units array
              @temp_units << item unless @temp_units.include?(item)
            else
              # Note:: While validating input data, collect invalid row(data) and process the others.
              # Display invalid data to user later
              @invalid_units << item unless @invalid_units.include?(item)
            end
          end
        end
        
      end
    else
      @errors << "Headers doesnot match the column counts"
    end
    
    # calculate valid_units
    @valid_units = @temp_units - @invalid_units
    
    {:valid_units => @valid_units, :invalid_units => @invalid_units}
  end
end