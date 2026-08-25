# frozen_string_literal: true

module ::AcademicRepository
  class Engine < ::Rails::Engine
    engine_name "academic_repository"
    isolate_namespace AcademicRepository
  end
end