require "rails_helper"

RSpec.describe "DevLoginController", type: :request do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.silence_get_warning = true
  end

  it "mocks requester and redirects into the OAuth flow" do
    get "/dev_login/requester"
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to("/auth/google_oauth2")
  end

  it "mocks agent and redirects into the OAuth flow" do
    get "/dev_login/agent"
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to("/auth/google_oauth2")
  end
end
