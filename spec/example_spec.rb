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

  #    "date": "2013-08-06",
  #    "define": {
  #    "system": "http://hl7.org/fhir/v3/AdministrativeGender",
  #    "caseSensitive": true,
  #"concept": [
  #    {
  #        "code": "F",
  #    "display": "Female",
  #    "definition": "Female"
  #},
  #    {
  #        "code": "M",
  #    "display": "Male",
  #    "definition": "Male"
  #},
  #    {
  #        "code": "UN",
  #    "display": "Undifferentiated",
  #    "definition": "The gender of a person could not be uniquely defined as male or female, such as hermaphrodite."
  #}
  #]
  #}
  #}


  example do
    sys = Terrminology::Facade.new(DB)

    sys.clear_value_sets!

    value_set = sys.create_value_set(
        identifier:   'http://hl7.org/fhir/v3/vs/AdministrativeGender',
        name:         'v3 Code System AdministrativeGender',
        publisher:    'HL7, Inc',
        description:  'The gender of a person used for adminstrative purposes (as opposed to clinical gender)',
        status:       'active',
        date:         '2013-08-06'
    )

    sys.value_sets.should include(value_set)

    define = sys.create_define(
        value_set_id: value_set.identity,
        system:             'http://hl7.org/fhir/v3/AdministrativeGender',
        case_sensitive:     true
    )

    sys.defines.should include(define)

    concept = sys.create_concept(
        define_id: define.identity,
        code:            'UN',
        display:         'Undifferentiated',
        definition:      'The gender of a person could not be uniquely defined as male or female, such as hermaphrodite.'
    )

    sys.concepts.should include(concept)
  end

  #example do
  #  sys = Terrminology::Facade.new(DB)
  #  sys.clear_users!
  #
  #  user = sys.create_user(name: 'nicola', password: '123456')
  #  sys.users.should include(user)
  #
  #  p sys.users
  #
  #  list_perm = sys.create_permission(:list_patients, 'Read Patient List')
  #  sys.permissions.should include(list_perm)
  #
  #  role = sys.create_role('Physicians', 'Just a inpatient physicians')
  #  sys.roles.should include(role)
  #
  #  sys.grant_permission(role.identity, list_perm.identity)
  #
  #  permissions = sys.role_permissions(role.identity)
  #  permissions.should include(list_perm)
  #
  #  sys.allowed?(user.identity, list_perm.identity).should_not be_true
  #  sys.assign_role(user.identity, role.identity)
  #
  #  sys.user_roles(user.identity).should include(role)
  #
  #  sys.allowed?(user.identity, UUID.generate).should_not be_true
  #
  #  sys.allowed?(user.identity, list_perm.identity).should be_true
  #
  #  sys.allowed?(user.identity, :list_patients).should be_true
  #end
end
