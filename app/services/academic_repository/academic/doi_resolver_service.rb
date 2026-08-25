# frozen_string_literal: true

require 'uri'
require 'json'

module ::AcademicRepository
  module Academic
    class DoiResolverService
      def self.call(doi:)
        new.call(doi: doi)
      end

      def call(doi:)
        return { success: false, error_message: "DOI boş olamaz" } if doi.blank?
        unless doi.match?(/^10.\d{4,9}\/[-._;()\/:A-Z0-9]+$/i)
          return { success: false, error_message: "Geçersiz DOI formatı" }
        end

        url = "https://api.crossref.org/works/#{URI.encode_www_form_component(doi)}"
        
        begin
          response = Excon.get(url, connect_timeout: 5, read_timeout: 5)
          return { success: false, error_message: "DOI bulunamadı" } unless response.status == 200
          
          raw_data = JSON.parse(response.body)
          { success: true, metadata: parse_metadata(raw_data) }
        rescue StandardError => e
          { success: false, error_message: "Crossref API erişim hatası: #{e.message}" }
        end
      end

      private

      def parse_metadata(raw_data)
        message = raw_data.dig("message") || {}
        {
          title: message.dig("title", 0),
          abstract: message.dig("abstract"),
          work_type: 'journal_article',
          venue_name: message.dig("container-title", 0),
          publication_date: extract_date(message),
          authors: parse_authors(message.dig("author") || []),
          raw_metadata: raw_data
        }
      end

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