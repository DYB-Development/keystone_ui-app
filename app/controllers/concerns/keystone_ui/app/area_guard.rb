# frozen_string_literal: true

module KeystoneUi
  module App
    module AreaGuard
      extend ActiveSupport::Concern

      class_methods do
        def in_area(area_name)
          before_action { refuse_when_area_is_closed(area_name) }
        end
      end

      private

      def refuse_when_area_is_closed(area_name)
        return if KeystoneUi::App.area_on?(view_context, area_name)

        refuse("keystone_ui/app/areas/off", area_name)
      end

      def refuse(page, area_name)
        respond_to do |format|
          format.html { render page, locals: { area_name: area_name }, status: :forbidden }
          format.any { head :forbidden }
        end
      end
    end
  end
end
