class InformationsController < ApplicationController
  skip_before_action :require_login, only: %i[terms_of_service privacy_policy how_to_used]
  def terms_of_service
  end

  def privacy_policy
  end

  def how_to_used
  end
end
