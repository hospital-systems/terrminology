require 'spec_helper'
require 'uuid'

describe Terrminology do
  subject { described_class }
  around(:each) do |example|
    DB.transaction do # BEGIN
      @sys = Terrminology.api(DB)
      @sys.clear_value_sets!
      @sys.clear_concept_maps!
      example.run
      raise Sequel::Rollback
    end
  end

  def rfile(name)
    File.read(File.dirname(__FILE__) + "/fixtures/#{name}")
  end

  example do
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

  describe '#create_concept_map with two concepts and two maps' do
    it 'should create concept map' do
      cm_def = JSON.parse(rfile('concept_map.json'))
      @sys.concept_maps.find{|cm| cm.identifier == cm_def['identifier']}.should be_nil
      concept_map = @sys.create_concept_map(cm_def)
      @sys.concept_maps.find{|cm| cm.identifier == cm_def['identifier']}.should_not be_nil
      @sys.source_concepts(concept_map.identity).size.should == 2
      @sys.source_concepts(concept_map.identity).map{|sc| @sys.maps(sc.identity).size}.inject(&:+).should == 2
    end
  end

  describe '#load_mapping' do
    it 'should load mapping' do
      filename = 'v2_to_fhir_gender.json'
      idn = 'v2_to_fhir_gender'

      @sys.concept_maps.find{|cm| cm.identifier == idn}.should be_nil
      concept_map = @sys.load_concept_map(filename)
      @sys.concept_maps.find{|cm| cm.identifier == idn}.should_not be_nil

      @sys.source_concepts(concept_map.identifier).size.should == 6
      @sys.source_concepts(concept_map.identity).map{|sc| @sys.maps(sc.identity).size}.inject(&:+).should == 6
    end
  end

  describe '#map_concept' do
    it 'should return mapped concept coding for the source code' do
      @sys.load_value_set('v3-AdministrativeGender.json')
      @sys.load_value_set('v3-NullFlavor.json')
      @sys.load_value_set('valueset-administrative-gender.json')

      cm_def = JSON.parse(rfile('concept_map.json'))

      concept_map    = @sys.create_concept_map(cm_def)
      source_concept = @sys.source_concepts(concept_map.identifier).first
      map            = @sys.maps(source_concept.identity).first

      mapped         = @sys.map_concept(concept_map.source, source_concept.code, concept_map.target)
      mapped.should_not       be_nil
      mapped[:code].should   == map[:code]
      mapped[:value_set].should == concept_map.target
    end
  end

  describe '#load_all_value_sets' do
    it 'should load all value sets resolving requirements' do
      loaded = @sys.load_all_value_sets[:loaded]
      @sys.value_sets.size.should == loaded
    end
  end
end
