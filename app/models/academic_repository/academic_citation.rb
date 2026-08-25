# frozen_string_literal: true

class AcademicCitation < ActiveRecord::Base
  belongs_to :source_work, class_name: 'AcademicWork'
  belongs_to :target_work, class_name: 'AcademicWork', optional: true
end