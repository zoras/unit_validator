require 'faster_csv'
require 'roo'
require 'active_support/core_ext/object/blank'
require 'generic_spreadsheet'
require 'validator_helpers'

module CF
  class InputValidator
    include ValidatorHelpers

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

    # returns a hash of arrays with two keys :valid_units and :invalid_units
    # {:valid_units => @valid_units, :invalid_units => @invalid_units}
    def parse_and_validate(inputs)
      csv_contents = FasterCSV.parse(inputs)
      csv_header = csv_contents[0].map{|a| a.strip unless a.nil? }

      # Initialize rule_labels array and store labels of RULE_HEADERS into it
      rule_labels = Array.new
      rules.each do |rule|
        rule_labels << rule[:label]
      end

      if rule_labels == csv_header
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
end