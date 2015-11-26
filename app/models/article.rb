class Article < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_everywhere, against: [:title, :text]
  acts_as_taggable
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
            length: { minimum: 5 }
  has_and_belongs_to_many :groups
end
