# frozen_string_literal: true

module ::AcademicRepository
  class AcademicWorkAuthor < ::ActiveRecord::Base
    belongs_to :academic_work, class_name: 'AcademicRepository::AcademicWork'
    belongs_to :academic_author, class_name: 'AcademicRepository::AcademicAuthor'

    validates :author_order, numericality: { greater_than: 0 }
  end
end