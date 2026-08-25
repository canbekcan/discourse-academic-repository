# frozen_string_literal: true

module ::AcademicRepository
  class AcademicWorksController < ::ApplicationController
    requires_plugin "academic-repository"
    requires_login

    def create
      RateLimiter.new(current_user, "create_academic_work", 3, 1.minute).performed!

      work = AcademicWork.new(create_params.merge(created_by_user_id: current_user.id))
      
      if work.save
        # Asynchronously calculate citations using the newly saved work
        Academic::CitationGraphService.call(work_id: work.id)
        render json: serialize_data(work, AcademicWorkSerializer), status: :created
      else
        render_json_error(work.errors.full_messages.join(", "), status: :unprocessable_entity)
      end
    end

    def resolve_doi
      RateLimiter.new(current_user, "resolve_doi", 10, 1.minute).performed!
      
      result = Academic::DoiResolverService.call(doi: params[:doi])
      
      if result[:success]
        render json: result[:metadata], status: :ok
      else
        render_json_error(result[:error_message], status: :not_found)
      end
    end

    private

    def create_params
      params.require(:academic_work).permit(
        :work_type, :title, :abstract, :doi, :isbn, :issn, :publication_date, 
        :venue_name, :volume, :issue, :pages
      )
    end
  end
end