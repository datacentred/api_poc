require_dependency "harbour/authorized_controller"

module Harbour
  module V1
    class UsageController < AuthorizedController
      include UsageDoc

      before_action :usage

      def show
        respond_with(UsageSerializer.new(usage, year, month).serialize)
      end

      private

      def year
        params[:year].to_i
      end

      def month
        params[:month].to_i
      end

      def usage
        t = Time.parse("#{year}-#{month}-01 00:00:00 UTC")
        raise ActionController::RoutingError.new('Not Found') if t > Time.now
        raise ActionController::RoutingError.new('Not Found') if t < current_organization.created_at.beginning_of_month
        UsageDecorator.new(current_organization, year, month).usage_data
      end
    end
  end
end

