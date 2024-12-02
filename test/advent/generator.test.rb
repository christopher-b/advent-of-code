generator = Advent::Generator.new(year: 2099, day: 1)
downloader = generator.downloader

test "downloader URL" do
  assert downloader.url == "https://adventofcode.com/2099/day/1/input"
end

test "downloader destination" do
  assert downloader.destination == "data/2099/01-data.txt"
end

test "downloader uses ENV for session cookie" do
  ENV["AOC_SESSION"] = "session_cookie"
  assert downloader.session_cookie == "session_cookie"
end

test "downloader headers" do
  ENV["AOC_SESSION"] = "session_cookie"
  assert downloader.headers == {"Cookie" => "session=session_cookie"}
end
