# features/step_definitions/common_steps.rb
Given("the database is seeded") do
  load Rails.root.join("db/seeds.rb")
end

When("I visit {string}") do |path|
  visit path
end

Then("I should see {string} on the page") do |text|
  expect(page).to have_content(text)
end

Then("I should be logged in") do
  expect(page).to have_content(/Signed in( as)?/i)
end

Then('I should be redirected with {string}') do |msg|
  expect(page).to have_content(msg)
end

# features/step_definitions/common_steps.rb
Then("I should see a list of tickets") do
  expect(page).to have_css('h1', text: 'Tickets')

  subjects = [
    "App crash on ticket submission",
    "Feature request: Email notifications for updates",
    "Billing discrepancy for premium plan"
  ]

  found = subjects.any? { |s| page.has_text?(s) }
  expect(found).to be(true), "Expected to see one of #{subjects.inspect}, got:\n#{page.text}"
end




Then("I should see a ticket with subject {string}") do |subject|
  expect(page).to have_content(subject)
end

Then('every ticket listed should have status {string}') do |status|
  # Ensure at least one status marker appears and none of the others
  within("[data-testid='tickets-list']") do
    expect(page).to have_css("[data-testid='ticket-status']", text: /Status:\s*#{Regexp.escape(status)}/i)
    (Ticket.statuses.keys - [ status ]).each do |other|
      expect(page).not_to have_css("[data-testid='ticket-status']", text: /Status:\s*#{Regexp.escape(other)}/i)
    end
  end
end

Given('I am logged in as the requester') do
  visit "/dev_login/user1"
end

Given('I am logged in as the support agent') do
  visit "/dev_login/agent1"
end

Given('a ticket exists with subject {string} and status {string}') do |subject, status|
  requester = User.find_by!(uid: "user1")
  assignee  = User.find_by!(uid: "agent1")
  Ticket.find_or_create_by!(subject: subject) do |t|
    t.description = "Seeded by Cucumber"
    t.status      = status
    t.priority    = :normal
    t.requester   = requester
    t.assignee    = assignee
    t.category    = "Test"
  end
end

When('I visit the ticket page for {string}') do |subject|
  ticket = Ticket.find_by!(subject: subject)
  visit Rails.application.routes.url_helpers.ticket_path(ticket)
end

When('I press {string}') do |label|
  begin
    click_button label
  rescue Capybara::ElementNotFound
    click_link label
  end
end

Then('the ticket {string} should have an assignee named {string}') do |subject, assignee_name|
  ticket = Ticket.find_by!(subject: subject)
  expect(ticket.assignee&.name).to eq(assignee_name)
end

When('I visit the edit page for {string}') do |subject|
  ticket = Ticket.find_by!(subject: subject)
  visit Rails.application.routes.url_helpers.edit_ticket_path(ticket)
end

When('I select {string} from {string}') do |value, field|
  select(value, from: field)
end

Then('the ticket {string} should have a non-empty {string}') do |subject, field|
  ticket = Ticket.find_by!(subject: subject)
  expect(ticket.send(field)).to be_present
end

Given('a user exists with email {string}') do |email|
  expect(User.find_by(email: email)).to be_present
end

When('I visit the edit page for user {string}') do |email|
  user = User.find_by!(email: email)
  visit Rails.application.routes.url_helpers.edit_user_path(user)
end
