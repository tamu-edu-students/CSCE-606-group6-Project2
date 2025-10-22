require "rails_helper"

RSpec.describe "DevLoginController", type: :request do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.silence_get_warning = true
  end

  it "mocks user1 and redirects into the OAuth flow" do
    # Ensure seed-like record exists for the uid used by dev login
    User.find_or_create_by!(provider: "google_oauth2", uid: "user1") do |u|
      u.email = "dummy.requester@example.com"
      u.name = "Dummy Requester"
      u.role = :user
    end
    get "/dev_login/user1"
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to("/auth/google_oauth2")
  end

  it "mocks agent1 and redirects into the OAuth flow" do
    User.find_or_create_by!(provider: "google_oauth2", uid: "agent1") do |u|
      u.email = "support.agent@example.com"
      u.name = "Support Agent"
      u.role = :staff
    end
    get "/dev_login/agent1"
    expect(response).to have_http_status(:redirect)
    expect(response).to redirect_to("/auth/google_oauth2")
  end

  it "redirects to root with alert when UID not found" do
    get "/dev_login/unknown_uid"
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include("No user found for UID unknown_uid")
  end
end
