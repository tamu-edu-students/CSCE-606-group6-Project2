class DevLoginController < ApplicationController
  # No auth; dev-only routes are environment-gated

  def requester
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid:      "dummy.requester.001",
      info: {
        email: "dummy.requester@example.com",
        name:  "Dummy Requester",
        image: "https://example.com/requester.png"
      },
      credentials: { token: "req-token", refresh_token: "req-refresh", expires_at: 1.hour.from_now.to_i }
    )
    redirect_to "/auth/google_oauth2"
  end

  def agent
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      provider: "google_oauth2",
      uid:      "support.agent.001",
      info: {
        email: "support.agent@example.com",
        name:  "Support Agent",
        image: "https://example.com/support_agent.png"
      },
      credentials: { token: "agent-token", refresh_token: "agent-refresh", expires_at: 1.hour.from_now.to_i }
    )
    redirect_to "/auth/google_oauth2"
  end
end
