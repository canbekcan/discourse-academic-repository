# frozen_string_literal: true

module ::AcademicRepository
  class AcademicAuthorSerializer < ::ApplicationSerializer
    attributes :id, :given_name, :family_name, :orcid, :email, :affiliation
  end
end