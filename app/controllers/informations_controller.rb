class InformationsController < ApplicationController
  skip_before_action :require_login, only: %i[terms_of_service privacy_policy]
  def terms_of_service
  end

  def privacy_policy
  end
end
