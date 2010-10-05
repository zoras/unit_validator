module ValidatorHelpers  
  
  private
  
  def required(rule, value)
    # returns true unless value is blank when required rule is true
    (rule && value.blank?) ? false : true
  end
  
  def valid(format, value)
    case format
    when "email"
      regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
    when "url" # image_data => url, path
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
    when "datetime"
      regex = /^(1[0-2]|0?[1-9])\/(3[01]|[12][0-9]|0?[1-9])\/(?:[0-9]{2})?[0-9]{2}|(([0-1]?[0-9])|([2][0-3])):([0-5]?[0-9])(:([0-5]?[0-9]))?$/
    when "currency" #=> for USD
      regex = /^\$?(?:\d+|\d{1,3}(?:,\d{3})*)(?:\.\d{1,2}){0,1}$/
    # when "boolean"
    # when "rating"
    # when "radio"
    # when "checkbox" => multiple choice
    when "general"
      return true
    else
      puts "Invalid format:: #{format}"
      return false
    end

    if !value.nil?
      !value.match(regex).nil? ? true : false
    else
      return false
    end
  end

  def check_date(value)
    begin
      val = value.scan(/^(\d{1,2})[\/|-|\.|\s](\d{1,2})[\/|-|\.|\s](\d{2,4})$/) # dd.mm.yyyy
      Date.civil(val[0][2].to_i,val[0][1].to_i,val[0][0].to_i) # civil check julian date in yyyy.mm.dd
      !val.blank? ? true : false
    rescue
      return false
    end
  end
end