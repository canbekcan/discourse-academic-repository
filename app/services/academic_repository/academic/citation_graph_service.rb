# frozen_string_literal: true

module ::AcademicRepository
  module Academic
    class CitationGraphService
      def self.call(work_id:)
        new.lock_and_process(work_id: work_id)
      end

      def lock_and_process(work_id:)
        DistributedMutex.synchronize("academic_citation_graph_#{work_id}") do
          work = AcademicWork.find_by(id: work_id)
          return { success: false, error: "Eser bulunamadı" } unless work

          recalculate_incoming_citations(work)
          { success: true, work: work }
        end
      end

      private

      def recalculate_incoming_citations(new_work)
        return if new_work.doi.blank?

        AcademicCitation.where(target_doi: new_work.doi, target_work_id: nil).find_each do |citation|
          citation.update!(target_work_id: new_work.id)
        end
      end
    end
  end
end