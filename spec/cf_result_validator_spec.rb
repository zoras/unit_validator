require 'spec_helper'

describe CF::ResultValidator do
  it "should return a true boolean value (.valid?) if the rules match with result" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "website", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "url"
             }]

    # TODO
    # params = {:name => "Saroj", :site => "saroj.com"} which we've to convert to the following format
    result = "company name,website\nzorasinc,http://zorasinc.blogspot.com"

    @result_validator = CF::ResultValidator.new
    @result_validator.valid?(rules, result).should be_true
    @result_validator.errors.should be_empty
  end
  
  it "should return a false boolean value (.valid?) if the rules don't match with result and give particular error" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "website", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "url"
             }]

    result = "company name\nsaroz"

    @result_validator = CF::ResultValidator.new
    @result_validator.valid?(rules, result).should be_false
    @result_validator.errors.should_not be_empty
    @result_validator.errors.should include("website is/are required")
    
  end
  
  it "should give xtra headers provided error and return a false boolean value (.valid?) if the rules don't match with result" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "website", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "url"
             }]

    result = "company name, website, email\nsaroz"

    @result_validator = CF::ResultValidator.new
    @result_validator.valid?(rules, result).should be_false
    @result_validator.errors.should_not be_empty
    @result_validator.errors.should include("cannot process as the input data consists extra headers")
    
  end
  
  it "should give errors when validation fails" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "website", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "url"
             }]

    result = "company name, website\nsaroz, saroj@maharjan\nsprout, bttn://abc.com\nktm,"

    @result_validator = CF::ResultValidator.new
    @result_validator.valid?(rules, result).should be_false
    @result_validator.errors.should_not be_empty
    @result_validator.errors[0].should include("saroj@maharjan is not valid")
    @result_validator.errors[1].should include("bttn://abc.com is not valid")
    @result_validator.errors.should include("bttn://abc.com is not valid")
    @result_validator.errors.should include("website is required")
    @result_validator.errors.should include("saroj@maharjan is not valid","bttn://abc.com is not valid")
  end  
end