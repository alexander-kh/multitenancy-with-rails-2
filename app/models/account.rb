class Account < ApplicationRecord  
  belongs_to :owner, class_name: "User"
  accepts_nested_attributes_for :owner
  
  validates :subdomain, presence: true, uniqueness: true
  
  has_many :invitations
  has_many :memberships
  has_many :users, through: :memberships
  has_many :books
  belongs_to :plan
  
  has_many :subscription_events
  
  def subscribed?
    braintree_subscription_id.present?
  end
  
  def over_limit_for?(plan)
    books.count > plan.books_allowed
  end
end
