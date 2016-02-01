class Problem < ActiveRecord::Base
  acts_as_commentable
  mount_uploader :background_image, BackgroundImageUploader
  belongs_to :user
  belongs_to :category
  before_create :set_color
  
  has_many :comments, as: :commentable
  has_many :votes, through: :solutions
  has_many :solutions, dependent: :destroy

  accepts_nested_attributes_for :solutions, :allow_destroy => true, :reject_if => proc { |solution| solution['title'].blank? }

  validate :category_is_present
  validate :have_solutions
  validates :content, length: { in: 10..200 }

  def category_is_present
    if self.category_id.nil?
      errors.add(:base, "You must select a category")
    end
  end

  def have_solutions
    unless solutions.size.in?(2..4)
      errors.add(:base, "Must have at least 2 options but can not have more than 4.")
    end
  end

  def set_color
    self.color = ["#72C4B9", "#9A9C9F", "#6A486B", "#25354A", "#CDB5CD", "#A2B5CD", "#3b5998"].sample  
  end
end
