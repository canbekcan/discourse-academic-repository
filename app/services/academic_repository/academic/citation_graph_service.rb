# frozen_string_literal: true

module ::AcademicRepository
  module Academic
    class CitationGraphService
      # Inject the Service::Base module instead of inheriting from it
      include ::Service::Base
      
      step :lock_and_process

      def lock_and_process(work_id:)
        # Race condition'ı önlemek için DistributedMutex kullanıyoruz
        DistributedMutex.synchronize("academic_citation_graph_#{work_id}") do
          work = AcademicWork.find_by(id: work_id)
          return StandardResults::Failure("Eser bulunamadı") unless work

          recalculate_incoming_citations(work)
          StandardResults::Success(work: work)
        end
      end

      private

      def recalculate_incoming_citations(new_work)
        return if new_work.doi.blank?

        # Daha önce eklenmiş ama hedef DOI'si bizim DOI'miz ile eşleşen atıfları bağla
        AcademicCitation.where(target_doi: new_work.doi, target_work_id: nil).find_each do |citation|
          citation.update!(target_work_id: new_work.id)
        end
      end
    end
  end
end