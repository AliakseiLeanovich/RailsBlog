class User < ActiveRecord::Base

  has_and_belongs_to_many :groups
  has_and_belongs_to_many :roles

  has_many :articles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :nickname, :uniqueness => true

  def article_ids
    ids = []
    ids << articles.ids
    ids << groups.map {|group| group.article_ids}
    ids.flatten.uniq
  end

  def permissions
    permissions_hash = {create: false, read: false, update: false, delete: false}
    roles.each do |role|
      permissions_hash[:create] = true if role.create_ability
      permissions_hash[:read] = true if role.read_ability
      permissions_hash[:update] = true if role.update_ability
      permissions_hash[:delete] = true if role.delete_ability
    end
    permissions_hash
  end
end
