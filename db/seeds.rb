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
  uid:      "user1" # stable for idempotency
)

requester.assign_attributes(
  email:     "dummy.requester@example.com",
  name:      "Dummy Requester",
  image_url: "https://example.com/requester.png",
  role:      :user
)

requester.save!
puts "Seeded requester: #{requester.email} (role: #{requester.role})"

# === Second Dummy OAuth User (Requester 2) ===
requester2 = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "user2"
)

requester2.assign_attributes(
  email:     "dummy.requester2@example.com",
  name:      "Dummy Requester Two",
  image_url: "https://example.com/requester2.png",
  role:      :user
)

requester2.save!
puts "Seeded requester: #{requester2.email} (role: #{requester2.role})"


# === Dummy OAuth Support Agent (no password) ===
support_agent = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "agent1" # stable for idempotency
)

support_agent.assign_attributes(
  email:     "support.agent@example.com",
  name:      "Support Agent",
  image_url: "https://example.com/support_agent.png",
  role:      :staff
)

support_agent.save!
puts "Seeded support agent: #{support_agent.email} (role: #{support_agent.role})"

# === Second OAuth Support Agent ===
support_agent2 = User.find_or_initialize_by(
  provider: "google_oauth2",
  uid:      "agent2"
)

support_agent2.assign_attributes(
  email:     "support.agent2@example.com",
  name:      "Support Agent Two",
  image_url: "https://example.com/support_agent2.png",
  role:      :staff
)

support_agent2.save!
puts "Seeded support agent: #{support_agent2.email} (role: #{support_agent2.role})"


ticket_data = [
  {
    subject: "App crash on ticket submission",
    description: "Every time I try to submit a ticket, the app crashes with a 500 error.",
    status: :open,
    priority: :high,
    requester_id: requester.id,
    assignee_id: support_agent.id,
    category: "Bug",
    closed_at: nil
  },
  {
    subject: "Cannot change account password",
    description: "The password reset link redirects to an expired page.",
    status: :pending, # was :in_progress → fix to :pending
    priority: :normal,
    requester_id: requester.id,
    assignee_id: support_agent.id,
    category: "Authentication",
    closed_at: nil
  },
  {
    subject: "Feature request: Email notifications for updates",
    description: "Would be great if I could receive an email when the ticket status changes.",
    status: :open,
    priority: :low,
    requester_id: requester.id,
    assignee_id: nil,
    category: "Feature Request",
    closed_at: nil
  },
  {
    subject: "Billing discrepancy for premium plan",
    description: "Charged twice for the same month on my credit card statement.",
    status: :closed,
    priority: :high,
    requester_id: requester.id,
    assignee_id: support_agent.id,
    category: "Billing",
    closed_at: 1.day.ago
  },
  {
    subject: "Resolved: UI glitch on dashboard",
    description: "Dashboard charts overlapped on Safari; fix deployed.",
    status: :resolved,
    priority: :normal,
    requester_id: requester.id,
    assignee_id: support_agent.id,
    category: "UI",
    closed_at: nil
  }
]

ticket_data.each do |attrs|
  Ticket.find_or_create_by!(subject: attrs[:subject]) do |t|
    t.assign_attributes(attrs)
  end
end


puts "Seeded #{Ticket.count} total tickets (including existing ones)."
