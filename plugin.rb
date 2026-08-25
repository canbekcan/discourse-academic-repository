# name: discourse-academic-repository
# about: BEKCAN Academic Citation & Repository Plugin
# version: 0.1.0
# authors: Can Bekcan
# url: https://github.com/canbekcan/discourse-academic-repository
# required_version: 3.2.0

enabled_site_setting :academic_repository_enabled

require_relative "lib/academic_repository/engine"

after_initialize do
  Discourse::Application.routes.append do
    mount ::AcademicRepository::Engine, at: "/academic"
  end
end