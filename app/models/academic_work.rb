# frozen_string_literal: true

class AcademicWork < ActiveRecord::Base
  enum work_type: { 
    journal_article: 0, 
    book: 1, 
    book_chapter: 2, 
    thesis: 3, 
    conference_paper: 4, 
    report: 5, 
    other: 6 
  }

  belongs_to :creator, class_name: 'User', foreign_key: 'created_by_user_id', optional: true
  
  has_many :academic_work_authors, dependent: :destroy
  has_many :authors, through: :academic_work_authors, source: :academic_author

  has_many :outgoing_citations, class_name: 'AcademicCitation', foreign_key: 'source_work_id', dependent: :destroy
  has_many :incoming_citations, class_name: 'AcademicCitation', foreign_key: 'target_work_id', dependent: :nullify

  has_many :user_academic_profiles, dependent: :destroy
  has_many :owners, through: :user_academic_profiles, source: :user

  validates :title, presence: true
end