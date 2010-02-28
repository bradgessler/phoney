require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Phoney" do
  ['555 555 5555', '1 555 555 5555', 5555555555, 15555555555, '+1 555-555-5555', '+1 (555) 555-5555', '555.555.5555'].each do |num|
    it "should canonicalize #{num} to 5555555555" do
      Phoney::PhoneNumber.new(num).to_s.should eql('+1 (555) 5555555')
    end
  end
end