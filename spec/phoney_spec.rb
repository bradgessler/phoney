require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Phoney" do
  ['555 555 5555', '1 555 555 5555', 5555555555, 15555555555, '+1 555-555-5555', '+1 (555) 555-5555', '555.555.5555'].each do |num|
    it "should canonicalize #{num} to 5555555555" do
      number = Phoney::PhoneNumber.new(num)
      number.area_code.should eql('555')
      number.country_code.should eql('1')
      number.number.should eql('5555555')
      number.digits.should eql('15555555555')
    end
  end
end