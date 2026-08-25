# frozen_string_literal: true

module ::AcademicRepository
  module Academic
    class DoiResolverService
      # Inject the Service::Base module instead of inheriting from it
      include ::Service::Base
      
      step :validate_input
      step :fetch_from_crossref
      step :parse_metadata

      def validate_input(doi:)
        return StandardResults::Failure("DOI boş olamaz") if doi.blank?
        # DOI regex doğrulaması
        doi.match?(/^10.\d{4,9}\/[-._;()\/:A-Z0-9]+$/i) ? StandardResults::Success(doi: doi) : StandardResults::Failure("Geçersiz DOI formatı")
      end

      def fetch_from_crossref(doi:)
        url = "https://api.crossref.org/works/#{URI.encode_www_form_component(doi)}"
        
        begin
          response = Excon.get(url, connect_timeout: 5, read_timeout: 5)
          return StandardResults::Failure("DOI bulunamadı") unless response.status == 200
          
          StandardResults::Success(raw_data: JSON.parse(response.body))
        rescue StandardError => e
          StandardResults::Failure("Crossref API erişim hatası: #{e.message}")
        end
      end

      def parse_metadata(raw_data:)
        message = raw_data.dig("message")
        
        metadata = {
          title: message.dig("title", 0),
          abstract: message.dig("abstract"),
          work_type: 'journal_article',
          venue_name: message.dig("container-title", 0),
          publication_date: extract_date(message),
          authors: parse_authors(message.dig("author") || []),
          raw_metadata: raw_data
        }

        StandardResults::Success(metadata: metadata)
      end

      private

      def extract_date(message)
        date_parts = message.dig("published-print", "date-parts", 0) || message.dig("published-online", "date-parts", 0)
        return nil unless date_parts
        Date.new(*date_parts) rescue nil
      end

      def parse_authors(authors_array)
        authors_array.map do |author|
          {
            given_name: author["given"],
            family_name: author["family"],
            orcid: author["ORCID"]&.gsub(/https?:\/\/orcid.org\//, '')
          }
        end
      end
    end
  end
end