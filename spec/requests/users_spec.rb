require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/user/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /upload" do
    it "returns http found if no file present" do
      post "/user/upload"
      expect(response).to have_http_status(:found)
    end

    it "returns http found if no CSV file present" do
      bad_file = fixture_file_upload(file_fixture('bad.txt'))
      post "/user/upload", params: { users: bad_file }
      expect(response).to have_http_status(:found)
    end

    it "returns http success if CSV file present" do
      csv_file = fixture_file_upload(file_fixture('good.csv'), 'text/csv')
      post "/user/upload", params: { users: csv_file }
      expect(response).to have_http_status(:success)
    end
  end
end
