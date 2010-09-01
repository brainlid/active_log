class ActiveLog < ActiveRecord::Base
  belongs_to :ar, :polymorphic => true
  # The "Hash" specification causes an exception to be raised when loading the data
  # and the serialized content isn't a supported Hash.
  serialize :changed_content, Hash
  
  validates_inclusion_of :was_created, :in => [true, false]

end
