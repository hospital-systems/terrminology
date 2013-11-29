require 'spec_helper'
require 'uuid'

describe Terrminology::Utils do
  subject { described_class }

  it "#underscore"  do
    subject.underscore("AbraCadabra").should == 'abra_cadabra'
  end

  it "#normalize_attributes"  do
    attrs = {
      AbraCadabra: {
        AbraCadabra: [
          { AbraCadabra: 3 }
        ]
      }
    }
    subject.normalize_attributes(attrs)['abra_cadabra']['abra_cadabra'].first['abra_cadabra'].should == 3
  end
end
