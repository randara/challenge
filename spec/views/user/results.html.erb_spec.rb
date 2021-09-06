require 'rails_helper'

RSpec.describe "user/results", type: :view do
   it 'shows results' do
    userA = User.create(name: 'Axel', password: '000aaaBBBccccDDD')
    userB = User.create(name: 'Muhammad', password: 'QPFJWz1343439')
    @users = [userA, userB]

    render

    expect(rendered).to have_content('Results')
    expect(rendered).to have_content('Muhammad was successfully saved')
    expect(rendered).to have_content("Change 5 characters of Axel's password")
  end
end
