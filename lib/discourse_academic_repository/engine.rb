# frozen_string_literal: true

module ::DiscourseAcademicRepository
  class Engine < ::Rails::Engine
    engine_name "discourse_academic_repository"
    isolate_namespace DiscourseAcademicRepository
    
    config.after_initialize do
      Discourse::PluginRegistry.push_routes {
        # Frontend Ember rotaları buraya eklenecek
      }
    end
  end
end