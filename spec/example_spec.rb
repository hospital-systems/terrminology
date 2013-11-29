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
    sys = Terrminology.api(DB)

    sys.clear_value_sets!

    vs_def = JSON.parse(rfile('valueset-status.json'))
    idn = 'http://hl7.org/fhir/vs/valueset-status'

    sys.value_sets.find{|vs| vs.identifier == idn }.should be_nil

    vs = sys.create_value_set(vs_def)

    sys.value_sets.find{|v| v.identifier == idn }.should_not be_nil

    sys.find_value_set(vs.identifier).identifier.should == vs.identifier

    sys.concepts(vs.identifier).find{|c| c.code == 'active'}.should_not be_nil
    sys.concepts(vs.identity).find{|c| c.code == 'active'}.should_not be_nil

    sys.concepts(vs.identifier, code: 'active').first.code.should == 'active'

    sys.concepts(vs.identity, code: 'active').first.code.should == 'active'

    attrs = { code: 'reactivated', display: 'Reactivated', definition: 'Reactivated'}

    sys.concepts(vs.identifier, attrs).should be_empty
    concept = sys.add_concept(vs.identifier, attrs)
    sys.concepts(vs.identifier, attrs).should_not be_empty

    concepts_amount = sys.concepts(vs.identity).size

    concepts_amount.should_not == 0
    sys.remove_concept(concept.identity)

    sys.concepts(vs.identifier, attrs).should be_empty
    sys.concepts(vs.identity).size.should == concepts_amount - 1
  end
end
