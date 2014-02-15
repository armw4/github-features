Given(/I view pull request \#(\d+) in "(.*?)"$/) do |number, hub_path|
  hub = hub_path.to_hub

  @pull_request = PullRequest.new

  @pull_request.load(:user => hub[:user], :repo => hub[:repo], :number => number)
end

Then(/I should see the number of files I changed in the "(.*?)" tab$/) do |tab_name|
  @pull_request.tab(tab_name).click

  @files_count = @pull_request.files_count

  expect(@files_count).to be > 0
end

Then(/I should see a message containing the number of files I changed$/) do
  expect(@pull_request.files_changed_count).to eq "#{@files_count} changed files"
end

Then(/I should see a diff for each file I changed/) do
  expect(@pull_request.diffs.length).to eq @files_count
end
