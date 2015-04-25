class Ticket < ActiveRecord::Base
  belongs_to :department
  has_many :owners
  has_many :users, through: :owners
  has_many :statuses
  #accepts_nested_attributes_for :statuses
  has_many :status_types, through: :statuses
  has_many :answers

  validates :name, presence: true, length: { in: 3..30 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { in: 3..127 }, format: { with: VALID_EMAIL_REGEX }

  validates :department, presence: true
  #validates_associated: department

  VALID_REFERENCE_REGEX = /[AAA-ZZZ]\-\d{6}/
  validates :reference, presence: true, uniqueness: true, format: { with: VALID_REFERENCE_REGEX }

  validates :subject, presence: true, length: { in: 5..255 }
  validates :body, presence: true, length: { in: 15..4000 }

  before_validation :set_reference, on: :create
  after_create :set_status_waiting_for_staff_response

  def self.search(query)
    where("reference = ? OR subject LIKE ?", query, "%#{query}%").order(:reference, created_at: :desc)
  end

  private

    def generate_reference
      prefix = ('AAA'..'ZZZ').to_a.sample
      sufix = (0..9).to_a.sample(6).join
      "#{prefix}-#{sufix}"
    end

    def get_unique_reference
      reference = generate_reference
      5.times do # Try 5 times to generete unique reference
        if Ticket.where(reference: reference).first
          reference = generate_reference
        else
          break
        end
      end
      reference
    end

    def set_reference
      self.reference = get_unique_reference
    end

    def set_status_waiting_for_staff_response
      status = Status.new
      status.status_type = StatusType.where(name: "Waiting for Staff Response").first
      status.ticket = self
      status.user = nil
      status.save
    end

end
