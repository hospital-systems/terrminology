require 'spec_helper'
require 'uuid'

describe Terrminology do
  subject { described_class }
  around(:each) do |example|
    DB.transaction do # BEGIN
      example.run
      raise Sequel::Rollback
    end
  end

  def rfile(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}")
  end

  example do
    sys = Terrminology::Facade.new(DB)

    sys.clear_value_sets!

    vs_def = JSON.parse(rfile('valueset-status.json'))

    sys.value_sets.find {|vs|
      vs.identifier == 'http://hl7.org/fhir/vs/valueset-status'
    }.should be_nil

    vs = sys.create_value_set(vs_def)

    sys.value_sets.find {|v|
      v.identifier == 'http://hl7.org/fhir/vs/valueset-status'
    }.should_not be_nil

    sys.find_valueset(vs.identifier).identifier.should == vs.identifier

    sys.concepts(vs.identifier).find{|c| c.code == 'active'}.should_not be_nil
    sys.concepts(vs.identity).find{|c| c.code == 'active'}.should_not be_nil

    sys.concepts(vs.identity)
  end
end
