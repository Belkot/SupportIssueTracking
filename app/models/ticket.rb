class Ticket < ActiveRecord::Base
  belongs_to :department, -> { where enable: true }
  has_many :owners
  has_many :users, through: :owners
  has_many :statuses
  has_many :status_types, through: :statuses
  has_many :answers

  before_validation :set_reference, on: :create

  validates :name, presence: true, length: { in: 3..30 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  #validates :email, presence: true, length: { in: 5..127 }, format: { with: VALID_EMAIL_REGEX }
  validates :email, presence: true, length: { in: 5..127 }, email: true

  validates :department, presence: true

  VALID_REFERENCE_REGEX = /[AAA-ZZZ]\-\d{6}/
  validates :reference, presence: true, uniqueness: true, format: { with: VALID_REFERENCE_REGEX }

  validates :subject, presence: true, length: { in: 5..255 }
  validates :body, presence: true, length: { in: 15..4000 }

  after_create :set_status_waiting_for_staff_response

  def self.search(query)
    where("reference = ? OR subject LIKE ?", query, "%#{query}%").order(:reference, created_at: :desc)
  end

  def self.unassigned
     where.not(id: Owner.distinct.pluck(:ticket_id))
  end

  def self.open
    sql_query = " SELECT ticket_id " +
                " FROM (           " +
                "       SELECT MAX(statuses.created_at) AS maximum_created_at," +
                "              ticket_id AS ticket_id,                        " +
                "              status_type_id                                 " +
                "       FROM statuses                                         " +
                "       GROUP BY ticket_id                                    " +
                "      )                                                      " +
                " WHERE status_type_id NOT IN (                         " +
                "                              SELECT id                " +
                "                              FROM status_types        " +
                "                              WHERE name = 'Completed' " +
                "                                 OR name = 'Cancelled' " +
                "                                 OR name = 'On Hold'   " +
                "                             )"
    find get_ticket_ids(sql_query)
  end

  def self.onhold
    sql_query = " SELECT ticket_id " +
                " FROM (           " +
                "       SELECT MAX(statuses.created_at) AS maximum_created_at," +
                "              ticket_id AS ticket_id,                        " +
                "              status_type_id                                 " +
                "       FROM statuses                                         " +
                "       GROUP BY ticket_id                                    " +
                "      )                                                      " +
                " WHERE status_type_id = (                       " +
                "                         SELECT id              " +
                "                         FROM status_types      " +
                "                         WHERE name = 'On Hold' " +
                "                        )"
    find get_ticket_ids(sql_query)
  end

  def self.closed
    sql_query = " SELECT ticket_id " +
                " FROM (           " +
                "       SELECT MAX(statuses.created_at) AS maximum_created_at," +
                "              ticket_id AS ticket_id,                        " +
                "              status_type_id                                 " +
                "       FROM statuses                                         " +
                "       GROUP BY ticket_id                                    " +
                "      )                                                      " +
                " WHERE status_type_id IN (                          " +
                "                          SELECT id                 " +
                "                          FROM status_types         " +
                "                          WHERE name = 'Cancelled'  " +
                "                             OR name = 'Completed'  " +
                "                         )"
    find get_ticket_ids(sql_query)
  end

  private

    def self.get_ticket_ids(sql_query)
      st = Status.find_by_sql(sql_query)
      st.map(&:ticket_id)
    end

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
      Status.new.set_waiting_for_staff_response self
    end

end
