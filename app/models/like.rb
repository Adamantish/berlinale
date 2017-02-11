class Like < ActiveRecord::Base

  belongs_to :traveller
  belongs_to :to_do
  validates_presence_of :to_do, :traveller

  validates :to_do ,uniqueness: { scope: :traveller, message: "Hey you can't like it THAT much!"}

end
