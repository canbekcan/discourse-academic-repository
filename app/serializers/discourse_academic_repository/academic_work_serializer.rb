# frozen_string_literal: true

module ::DiscourseAcademicRepository
  class AcademicWorkSerializer < ::ApplicationSerializer
    # BlockedSerializationError almamak için sadece dışarı açılması güvenli olan alanlar
    attributes :id, :work_type, :title, :abstract, :doi, :isbn, :publication_date, :venue_name
    
    has_many :authors, serializer: AcademicAuthorSerializer
    has_one :creator, serializer: BasicUserSerializer
  end
end