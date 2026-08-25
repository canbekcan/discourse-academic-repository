# frozen_string_literal: true

module ::AcademicRepository
  class AcademicAuthor < ::ActiveRecord::Base
    belongs_to :matched_user, class_name: 'User', foreign_key: 'matched_user_id', optional: true
    
    has_many :academic_work_authors, dependent: :destroy
    has_many :academic_works, through: :academic_work_authors

    validates :family_name, presence: true
  end
end