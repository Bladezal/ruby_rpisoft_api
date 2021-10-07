class Person < ApplicationRecord
    #acts_as_paranoid
    
    belongs_to :project, optional: true
    belongs_to :role, optional: true
    belongs_to :country, optional: true
    has_many :clients
    has_many :employees

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :birth_date
    validates :doc_number, uniqueness: true
    validates :sex, inclusion: { in: %w(Masc Fem)}
end
