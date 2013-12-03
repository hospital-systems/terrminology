require 'spec_helper'
require 'uuid'

describe Terrminology do
  subject { described_class }
  around(:each) do |example|
    DB.transaction do # BEGIN
      @sys = Terrminology.api(DB)
      example.run
      raise Sequel::Rollback
    end
  end

  def rfile(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}")
  end

  example do

    @sys.clear_value_sets!

    vs_def = JSON.parse(rfile('valueset-status.json'))
    idn = 'http://hl7.org/fhir/vs/valueset-status'

    @sys.value_sets.find{|vs| vs.identifier == idn }.should be_nil

    vs = @sys.create_value_set(vs_def)

    @sys.value_sets.find{|v| v.identifier == idn }.should_not be_nil

    @sys.find_value_set(vs.identifier).identifier.should == vs.identifier

    @sys.concepts(vs.identifier).find{|c| c.code == 'active'}.should_not be_nil
    @sys.concepts(vs.identity).find{|c| c.code == 'active'}.should_not be_nil

    @sys.concepts(vs.identifier, code: 'active').first.code.should == 'active'

    @sys.concepts(vs.identity, code: 'active').first.code.should == 'active'

    attrs = { code: 'reactivated', display: 'Reactivated', definition: 'Reactivated'}

    @sys.concepts(vs.identifier, attrs).should be_empty
    concept = @sys.add_concept(vs.identifier, attrs)
    @sys.concepts(vs.identifier, attrs).should_not be_empty

    concepts_amount = @sys.concepts(vs.identity).size

    concepts_amount.should_not == 0
    @sys.remove_concept(concept.identity)

    @sys.concepts(vs.identifier, attrs).should be_empty
    @sys.concepts(vs.identity).size.should == concepts_amount - 1
  end

  describe '#load_value_set' do
    it 'should load defined linear value set' do
      idn = 'http://hl7.org/fhir/v2/vs/0001'
      @sys.find_value_set(idn).should be_nil
      @sys.load_value_set('v2-0001.json')
      @sys.find_value_set(idn).should_not be_nil
    end

    it 'should load defined hierarchical value set' do
      idn = 'http://hl7.org/fhir/v3/vs/NullFlavor'
      @sys.find_value_set(idn).should be_nil
      @sys.load_value_set('v3-NullFlavor.json')
      @sys.find_value_set(idn).should_not be_nil
    end

    it 'should raise an exception loading a composed value set if a required value set is missing' do
      idn = 'http://hl7.org/fhir/vs/administrative-gender'
      @sys.find_value_set(idn).should be_nil
      expect {
        @sys.load_value_set('valueset-administrative-gender.json')
      }.to raise_error(ArgumentError)
      @sys.find_value_set(idn).should be_nil
    end

    it 'should load composed value set if all required value sets are present' do
      idn = 'http://hl7.org/fhir/vs/administrative-gender'
      @sys.load_value_set('v3-AdministrativeGender.json')
      @sys.load_value_set('v3-NullFlavor.json')
      @sys.load_value_set('valueset-administrative-gender.json')
      @sys.find_value_set(idn).should_not be_nil
    end
  end
end
