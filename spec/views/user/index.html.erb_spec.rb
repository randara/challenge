require 'rails_helper'

RSpec.describe "user/index", type: :view do
  it 'shows upload form' do
    render

    expect(rendered).to have_content('User#index')
    expect(rendered).to have_button('Upload')
  end
end
