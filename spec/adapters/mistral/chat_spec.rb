require 'spec_helper'

RSpec.describe "#{Intelligence::Adapter[ :mistral ]} chat requests", :mistral do

  include_context 'vcr'

  before do
    raise "A MISTRAL_API_KEY must be defined in the environment." unless ENV[ 'MISTRAL_API_KEY' ]
  end

  # this is needed for mistral test to avoid the rate limit
  after( :each ) do | example |
    sleep 2 if example.metadata[ :record_cassettes ]
  end

  let( :adapter_with_invalid_key ) do
    Intelligence::Adapter[ :mistral ].build! do 
      key                     'this-key-is-not-valid'  
      chat_options do
        model                 'mistral-large-latest'
        max_tokens            16
        temperature           0
      end
    end
  end

  let( :adapter ) do
    Intelligence::Adapter[ :mistral ].build! do   
      key                     ENV[ 'MISTRAL_API_KEY' ]
      chat_options do
        model                 'mistral-large-latest'
        max_tokens            24
        temperature           0
      end
    end
  end

  let( :adapter_with_stop_sequence ) do
    Intelligence::Adapter[ :mistral ].build! do   
      key                     ENV[ 'MISTRAL_API_KEY' ]
      chat_options do
        model                 'mistral-large-latest'
        max_tokens            24
        temperature           0
        stop                  'five'
      end
    end
  end

  let( :vision_adapter ) do
    Intelligence::Adapter[ :mistral ].build! do   
      key                     ENV[ 'MISTRAL_API_KEY' ]
      chat_options do
        model                 'pixtral-12b-2409'
        max_tokens            32
        temperature           0
      end
    end
  end

  include_examples 'chat requests'
  include_examples 'chat requests with token limit exceeded'
  include_examples 'chat requests with stop sequence'
  include_examples 'chat requests with error response'
  # mistral currently supports text through the legacy content encoding 
  # while supporting vision through the modern content encoding making 
  # vision support challenging
  # include_examples 'chat requests with binary encoded images'
  include_examples 'chat requests without alternating roles'

end
