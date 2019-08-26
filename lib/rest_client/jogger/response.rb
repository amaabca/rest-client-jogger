module RestClient
  module Jogger
    class Response < Action
      def template
        Tilt::JbuilderTemplate.new root.join('templates', 'response_logging_template.json.jbuilder')
      end

      private

      def render_params(start, finish, id, opts)
        params = response_params(opts)
        super.merge(params)
      end

      def response_params(opts = {})
        response_headers = opts[:response].try(:headers) || {}
        response_body = opts[:response].try(:body).to_s.force_encoding('UTF-8')
        {
          exception: opts[:exception],
          response_headers: filtered_headers(response_headers),
          response_body: filter(body: response_body, headers: response_headers),
          code: opts[:response].try(:code)
        }
      end

      def filtered_headers(headers = {})
        Filters::Headers.new(data: headers).filter
      end
    end
  end
end
