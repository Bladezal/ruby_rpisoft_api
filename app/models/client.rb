class Client < ApplicationRecord
  #acts_as_paranoid
  
  belongs_to :person
  
  validates :client_doc_number presence: true, uniqueness: true
end
