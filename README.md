# Cloud Factory Input Validatior (CFInputValidator)

The CFInputValidator - Cloud Factory Input Validator is a simple gem to **validate** the *spreadsheet data* inputs as per the given rules.

This gem is being developed for Project **Cloud Factory** Copyright© [Sprout Technology International Limited](http://sprout-technology.com)

![Sprout logo](http://sprout-technology.com/images/logo.png) 

## Installation
	
In Gemfile
	source 'http://rubygems.org'
	gem 'c_f_input_validator'
	
	bundle install

OR 
	gem install c_f_input_validator
	
	require 'rubygems'
	require 'c_f_input_validator'

## Usage

The CFInputValidator checks if the **headers** of the provided spreadsheet matches with the corresponding **rules** *(checked by label)* and gives error message if it doesn't match.

The individual row of the spreadsheet undergoes the validation process and gives the final output as an array of **valid and invalid units**.
Later the valid and invalid units can be processed separately as required.

You can even check if a **file format** is supported by the gem.

The gem currently supports `validation_format` of `email`, `number`, `url`, `date` and `time` only.
It also checks if value is present if required is true.

## Example

1. Specify the rules, i.e `:label` `:required` `:validation_format`
		rules = [{:label => "company name",:required => true, :validation_format => "general"},
			 	 {:label => "email", :required => false, :validation_format => "email"}]

2. Provide data for validation:
		inputs = "company name,email\nSprout,info@sproutify.com\nApple,saroj@apple"

	**You can also give the file location as input**
		inputs = File.read("fixtures/gdoc.csv")

	* Check the file format with `check_extension(path)` method which gives you a 'boolean' value `:check`
	
		`file_location = "fixtures/gdoc.xlsxsfdsf"`
		
		`CFInputValidator.check_extension(file_location)[:check]`

	* This gem currently supports the following formats and 'must be converted into csv' before validation.
		* `inputs = File.read("fixtures/gdoc.csv")`
		* `inputs = Excel.new("fixtures/gdoc.xls").to_csv`
		* `inputs = Excelx.new("fixtures/gdoc.xlsx").to_csv`
		* `inputs = Openoffice.new("fixtures/gdoc.ods").to_csv`

3. Create a new constructor of *CFInputValidator* class passing the above **rules** as argument.

		cloud_validator = CFInputValidator.new(rules)

4. Call `parse_and_validate(data)` method passing the above inputs as arguments.
		val = cloud_validator.parse_and_validate(inputs)

5. Now you'll get both valid and invalid data in `:valid_units` and `:invalid_units` arrays respectively.
	* `val[:valid_units]`
	* `val[:invalid_units]`

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

### Copyright

Copyright© Sprout Technology International Limited. See LICENSE for details.