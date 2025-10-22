require "omniauth"
OmniAuth.config.test_mode = true
OmniAuth.config.silence_get_warning = true
# provide a default mock; DevLoginController overwrites per role
OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
  provider: "google_oauth2",
  uid:      "user1",
  info:     { email: "dummy.requester@example.com", name: "Dummy Requester" },
  credentials: { token: "fake", refresh_token: "fake", expires_at: 1.hour.from_now.to_i }
)
