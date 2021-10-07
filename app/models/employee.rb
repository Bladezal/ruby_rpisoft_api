class Employee < ApplicationRecord
  #acts_as_paranoid
  
  belongs_to :person

  validates :start_date, presence: true
end
