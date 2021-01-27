class Review < ApplicationRecord
  belongs_to :response
  belongs_to :reviewer, class_name: 'User'  
end
