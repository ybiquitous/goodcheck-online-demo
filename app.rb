require "sinatra"
require "goodcheck"
require "tempfile"

get "/" do
  erb :index
end

post "/test" do
  Tempfile.open do |t|
    t.write params["config"]
    t.rewind

    path = Pathname.new(t.path)
    test = Goodcheck::Commands::Test.new(
      stdout: StringIO.new,
      stderr: StringIO.new,
      config_path: path,
      force_download: false,
      home_path: path.parent,
    )

    exit_code = test.run
    unless exit_code == 0
      return [400, test.stdout.string]
    end
  rescue Psych::SyntaxError, StrongJSON::Type::UnexpectedFieldError => err
    return [400, "Invalid Configuration"]
  end

  200
end
