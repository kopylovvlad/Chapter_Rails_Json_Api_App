# frozen_string_literal: true

##
# Api/Registrations
module Api
  class RegistrationsController < ApiController
    include Api::RegistrationsDoc
    resource_description { short 'Api/Registrations endpoints' }

    def create
      @item = UserRegistrationService.create(item_params)
      if @item.errors.size == 0
        render :show
      else
        return render_json_errors @item.errors
      end
    end

    private

    def item_params
      params.require(:users).permit(
        :email, :email_confirmation, :login, :password, :password_confirmation
      )
    end
  end
end
