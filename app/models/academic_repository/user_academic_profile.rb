# frozen_string_literal: true

module ::AcademicRepository
  class UserAcademicProfile < ::ActiveRecord::Base
    enum :role, { primary_author: 0, co_author: 1, editor: 2 }

    belongs_to :user, class_name: '::User'
    belongs_to :academic_work, class_name: 'AcademicRepository::AcademicWork'
  end
end