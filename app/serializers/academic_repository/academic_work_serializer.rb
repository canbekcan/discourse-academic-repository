# frozen_string_literal: true

module ::AcademicRepository
  class AcademicWorkSerializer < ::ApplicationSerializer
    attributes :id, :work_type, :title, :abstract, :doi, :isbn, :publication_date, :venue_name
    
    # Resolves to AcademicRepository::AcademicAuthorSerializer via Zeitwerk
    has_many :authors, serializer: AcademicAuthorSerializer
    
    # Must use :: to break out of the engine namespace and access Discourse Core
    has_one :creator, serializer: ::BasicUserSerializer
  end
end