class Project < ApplicationRecord
    has_many :persons
    
    validates :name, presence: true, length:{in: 3..50}
end
