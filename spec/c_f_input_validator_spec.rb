require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "CFInputValidator" do

  it "should validate the csv file rows against the rules provided by FormFactory gem" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "email", :field_type => "text_data",
              :value => "spt@lala.com", :required => false, :validation_format => "email"
             }]
    inputs = "company name,email\nSprout,info@sproutify.com"
    output = [["Sprout","info@sproutify.com"]]

    cloud_validator = CFInputValidator.new(rules)
    val = cloud_validator.parse_and_validate(inputs)
    val[:valid_units].should == output
  end
  
  it "should not validate the csv file with extra headers" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             }]
    inputs = "company name,email\nSprout,info@sproutify.com"
    output = [["Sprout","info@sproutify.com"]]
            
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should_not == output
    cloud_validator.errors.should include("Headers doesnot math the column counts")
  end
  
  it "should not validate the csv file with invalid headers as per rules" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "email", :field_type => "text_data",
              :value => "spt@lala.com", :required => false, :validation_format => "email"
             }]
    inputs = "company name\nSprout,info@sproutify.com"
    output = [["Sprout","info@sproutify.com"]]
    
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs).should_not == output
    cloud_validator.errors.should include("Headers doesnot math the column counts")
  end
  
  it "should validate the input email by format rules" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "email", :field_type => "text_data",
              :value => "spt@lala.com", :required => false, :validation_format => "email"
             }]
    inputs = "company name,email\nSprout,info@sproutify.com\nApple,ram@apple.co.uk\nPatan,ram.gmail@apple.co.in"
    output = [["Sprout","info@sproutify.com"], ["Apple","ram@apple.co.uk"], ["Patan","ram.gmail@apple.co.in"]]

    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == output
  end
  
  it "should check valid & invalid email by format rules" do
    rules = [{:field_id => "field_1", :label => "company name", :field_type => "text_data", 
              :value => "Sprout", :required => true, :validation_format => "general"
             },
             {:field_id => "field_2", :label => "email", :field_type => "text_data",
              :value => "spt@lala.com", :required => false, :validation_format => "email"
             }]
    inputs = "company name,email\nSprout,info@sproutify.com\nApple,ram@apple\nPatan,ram.gmail@ap ple.co.in\nGmail,@gmail.com\nEmail,email@"
    valid_output = [["Sprout","info@sproutify.com"]]
    invalid_output = [["Apple", "ram@apple"], ["Patan", "ram.gmail@ap ple.co.in"], ["Gmail", "@gmail.com"], ["Email","email@"]]

    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:invalid_units].should == invalid_output
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == valid_output
  end
  
  it "should validate url" do
    rules = [{:field_id => "field_1", :label => "website", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "url"
             }]
    inputs = "website\nhttp://www.google.com\nabc"
    valid_output = [["http://www.google.com"]]
    invalid_output = [["abc"]]
    
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == valid_output
    cloud_validator.parse_and_validate(inputs)[:invalid_units].should == invalid_output
  end
  
  it "should validate number" do
    rules = [{:field_id => "field_1", :label => "Age", :field_type => "text_data",
              :value => "http:\\www.yahoo.com", :required => true, :validation_format => "number"
             }]
    inputs = "Age\n32\n@1"
    valid_output = [["32"]]
    invalid_output = [["@1"]]
    
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == valid_output
    cloud_validator.parse_and_validate(inputs)[:invalid_units].should == invalid_output
  end
  
  # dd.mm.yyyy
  it "should validate date" do
    rules = [{:field_id => "field_1", :label => "Date of Birth", :field_type => "text_data",
              :value => "01-01-2002", :required => true, :validation_format => "date"
             }]
    inputs = "Date of Birth\n15.12.2009\n1990-01-02"
    valid_output = [["15.12.2009"]]
    invalid_output = [["1990-01-02"]]
    
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == valid_output
    cloud_validator.parse_and_validate(inputs)[:invalid_units].should == invalid_output
  end
  
  it "should validate time" do
    rules = [{:field_id => "field_1", :label => "Now Time", :field_type => "text_data",
              :value => "12:24", :required => true, :validation_format => "time"
             }]
    inputs = "Now Time\n01:21\n23:12\n24:12"
    valid_output = [["01:21"],["23:12"]]
    invalid_output = [["24:12"]]
    
    cloud_validator = CFInputValidator.new(rules)
    cloud_validator.parse_and_validate(inputs)[:valid_units].should == valid_output
    cloud_validator.parse_and_validate(inputs)[:invalid_units].should == invalid_output
  end
  
  it "should check the file type and reject with error if its of the unsupported format" do
    file_location = "fixtures/gdoc.xlsx"
    CFInputValidator.check_extension(file_location)[:check].should == true
    
    file_location = "fixtures/gdoc.xlsxsfdsf"
    CFInputValidator.check_extension(file_location)[:check].should == false
    CFInputValidator.check_extension(file_location)[:error].should include("Invalid file! The specified format is not supported.")
  end
  
  it "should parse the input from .ods, .xlsx or .xls files" do
    
    file_location = "fixtures/gdoc.xlsx"
    inputs = Excelx.new(file_location).to_csv
    
    output = <<STR
"company name","email"
"Apple",
"sprout","info@sproutify.com"
,
,"inf o@ab c.com"
,
"DEF","  info@def.com   "
"GHI",
,
,
,
"  ","  "
STR
    inputs.should == output
    
    inputs = Excel.new("fixtures/gdoc.xls").to_csv
    inputs.should == output
    
    inputs = Openoffice.new("fixtures/gdoc.ods").to_csv
    output = <<STR
"company name","email"
"Apple",
"sprout","info@sproutify.com"
,
,"inf o@ab c.com"
,
"DEF","  info@def.com   "
"GHI",
,
,
,
,
STR
    inputs.should == output
  end
    
end
