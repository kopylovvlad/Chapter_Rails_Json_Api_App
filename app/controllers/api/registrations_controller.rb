# frozen_string_literal: true

##
# Api/Registrations
module Api
  class RegistrationsController < ApiController
    include Api::RegistrationsDoc
    resource_description { short 'Api/Registrations endpoints' }

    def create
      shape = UserRegistrationShape.new(item_params)
      if shape.valid?
        @item = UserMutator.create(item_params)
        render :show
      else
        return render_json_errors(shape.errors)
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
