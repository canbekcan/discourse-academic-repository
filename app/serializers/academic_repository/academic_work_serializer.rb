# frozen_string_literal: true

module ::AcademicRepository
  class AcademicWorkSerializer < ::ApplicationSerializer
    attributes :id, :work_type, :title, :abstract, :doi, :isbn, :publication_date, :venue_name
    
    has_many :authors, serializer: AcademicRepository::AcademicAuthorSerializer
    has_one :creator, serializer: ::BasicUserSerializer
  end
end