# frozen_string_literal: true

module ::AcademicRepository
  class AcademicCitation < ::ActiveRecord::Base
    belongs_to :source_work, class_name: 'AcademicRepository::AcademicWork'
    belongs_to :target_work, class_name: 'AcademicRepository::AcademicWork', optional: true
  end
end