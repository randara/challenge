require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should fail to create if name is not present' do
      expect{ 
        User.create!(password_digest: 'any_password')
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Name can't be blank")
    end

    it 'should fail to create if password_digest is not present' do
      expect{ 
        User.create!(name: 'any_name')
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Password can't be blank, Password digest can't be blank")
    end

    it 'should create a user if required attributes are present' do
      expect{ 
        User.create!(name: 'any_name', password_digest: 'any_password')
      }.to change{ User.count }.by(1)
    end
  end
end
