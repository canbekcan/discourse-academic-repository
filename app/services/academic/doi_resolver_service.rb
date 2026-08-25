# app/services/academic/doi_resolver_service.rb
module Academic
  class DoiResolverService < ::Service::Base
    step :validate_doi
    step :fetch_from_crossref
    
    def validate_doi(params)
      params[:doi].present? ? StandardResults::Success(params) : StandardResults::Failure('DOI required')
    end
  end
end