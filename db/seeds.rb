# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "keeganasmith2003" # keep stable so it's idempotent
)

user.assign_attributes(
  email:    "keeganasmith2003@tamu.edu",
  name:     "Keegan Smith",
  image_url: "https://example.com/keegana.png",
  role:     :sysadmin
)

# (Optional) if you want seed tokens for local testing:
# user.access_token  = "seed-access-token"
# user.refresh_token = "seed-refresh-token"
# user.access_token_expires_at = 2.hours.from_now

user.save!
puts "Seeded user: #{user.email} (role: #{user.role})"


# === Roles ===
# Ensure your User model has something like:
# enum role: { user: 0, staff: 1, support: 2, admin: 3 }

puts "Seeding dummy OAuth users and tickets…"

# === Dummy OAuth User (Requester) ===
requester = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "dummy.requester.001" # stable for idempotency
)

requester.assign_attributes(
  email:     "dummy.requester@example.com",
  name:      "Dummy Requester",
  image_url: "https://example.com/requester.png",
  role:      :user
)

requester.save!
puts "Seeded requester: #{requester.email} (role: #{requester.role})"


# === Dummy OAuth Support Agent (no password) ===
support_agent = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "support.agent.001" # stable for idempotency
)

support_agent.assign_attributes(
  email:     "support.agent@example.com",
  name:      "Support Agent",
  image_url: "https://example.com/support_agent.png",
  role:      :staff
)

support_agent.save!
puts "Seeded support agent: #{support_agent.email} (role: #{support_agent.role})"


