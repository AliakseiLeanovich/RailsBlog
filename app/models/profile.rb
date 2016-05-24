class Profile < ActiveRecord::Base
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :name, length: { minimum: 5 }
  validates :description, presence: true
  validates :lng, presence: true
  validates :lat, presence: true
  validates :rating, presence: true
  validates :rating, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1,
    less_than_or_equal_to: 5
  }
  belongs_to :user
end
