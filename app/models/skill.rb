class Skill < ApplicationRecord
  belongs_to :owner, class_name: 'User'

end
