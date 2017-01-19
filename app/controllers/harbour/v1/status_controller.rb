require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class StatusController < AuthorizedController

      def index
        respond_with({"status": "ok"})
      end

    end
  end
end