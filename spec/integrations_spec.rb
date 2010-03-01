require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

require 'active_record'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false # Don't crap the migration into our RSpecs
ActiveRecord::Schema.define(:version => 1) do
  create_table :contacts do |t|
    t.string :telephone
  end
end

Rails = true # Fake that rails is around...

Phoney::Integrations::Rails.init!

class Contact < ActiveRecord::Base
  phone_numbers :telephone
end

describe "Phoney Rails integration" do
  it "should convert attribute to Phoney::PhoneNumber" do
    c = Contact.new(:telephone => '555-555-5555')
    c.telephone.should be_instance_of(Phoney::PhoneNumber)
  end
  
  it "Should write to database in db format" do
    c = Contact.create(:telephone => '(555) 555.5555')
    c.send(:read_attribute, :telephone).should eql('15555555555')
  end
end