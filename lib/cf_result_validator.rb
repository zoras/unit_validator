module CF
  class ResultValidator
    include ValidatorHelpers
    attr_accessor :errors

    def initialize
      @errors = []
    end

    def empty?
      @errors.blank? ? true : false
    end

    def valid?(rules, result)
      csv_contents = FasterCSV.parse(result)
      csv_header = csv_contents[0].map{|a| a.strip unless a.nil? }

      rule_labels = Array.new
      rules.each do |rule|
        rule_labels << rule[:label]
      end
      
      bool = false
      case (rule_labels <=> csv_header)
      when 1
        # when input header is less than rule label
        @errors << "#{rule_labels - csv_header} is/are required"
      when -1
        # when input header is more than rule label
        @errors << "cannot process as the input data consists extra headers"
      when 0
        # if rule_labels == csv_header
        csv_contents[1..-1].each do |item|
          rules.each_with_index do |header, index|
            next unless item
            unless item.compact.empty?
              item[index].strip! if !item[index].nil?
              if required(header[:required], item[index]) and valid(header[:validation_format], item[index])
                bool = true
              else
                bool = false
                if header[:required] && item[index].blank?
                  @errors << "#{header[:label]} is required"
                else
                  @errors << "#{item[index]} is not valid"
                end
              end
            end
          end
        end
      end
      # finally return boolean for .valid?
      return bool
    end
  end
end