# frozen_string_literal: true

class AcademicWorkAuthor < ActiveRecord::Base
  belongs_to :academic_work
  belongs_to :academic_author

  validates :author_order, numericality: { greater_than: 0 }
end