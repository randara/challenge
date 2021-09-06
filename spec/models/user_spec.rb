require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'valid?' do
    before(:each) do
      @user = User.new(name: 'username')
    end

    it 'should not be valid without name and password' do
      @user.name = nil
      expect(@user.valid?).to be false
    end

    it 'should not be valid without password' do
      expect(@user.valid?).to be false
    end

    it 'should not be valid without name' do
      @user.name = nil
      @user.password = '1Password123'
      expect(@user.valid?).to be false
    end

    it 'should not be valid if password length is less than 10' do
      @user.password = '1'
      expect(@user.valid?).to be false
    end

    it 'should not be valid if password length is greater that 16' do
      @user.password = 'ABCDEFGHIJKLMNOPQR'
      expect(@user.valid?).to be false
    end

    it 'should not be valid without a lowercase char in password' do
      @user.password = '1PASSWORD123'
      expect(@user.valid?).to be false
    end

    it 'should not be valid without an uppercase char in password' do
      @user.password = '1password123'
      expect(@user.valid?).to be false
    end

    it 'should not be valid without a digit in password' do
      @user.password = 'PPasswordXYZ'
      expect(@user.valid?).to be false
    end

    it 'should not be valid with three or more repeating characters in password' do
      @user.password = '1Passsword123'
      expect(@user.valid?).to be false
    end

    it 'should be valid with name and password' do
      @user.password = '1Password123'
      expect(@user.valid?).to be true
    end
  end

  describe 'custom validation methods' do
    before(:each) do
      @user = User.new(name: 'username')
    end

    describe 'at_least_one_lowercase_character_in_password' do
      it 'should return error if password does not have a lowercase char' do
        @user.password = "A"
        expect(@user.send(:at_least_one_lowercase_character_in_password)).to_not be_nil
      end

      it 'should return nil if password does have a lowercase char' do
        @user.password = "a"
        expect(@user.send(:at_least_one_lowercase_character_in_password)).to be_nil
      end
    end

    describe 'at_least_one_uppercase_character_in_password' do
      it 'should return error if password does not have a uppercase char' do
        @user.password = "a"
        expect(@user.send(:at_least_one_uppercase_character_in_password)).to_not be_nil
      end

      it 'should return nil if password does have a uppercase char' do
        @user.password = "A"
        expect(@user.send(:at_least_one_uppercase_character_in_password)).to be_nil
      end
    end

    describe 'at_least_one_digit_in_password' do
      it 'should return error if password does not have a digit' do
        @user.password = "Aa"
        expect(@user.send(:at_least_one_digit_in_password)).to_not be_nil
      end

      it 'should return nil if password does have a digit' do
        @user.password = "1Aa"
        expect(@user.send(:at_least_one_digit_in_password)).to be_nil
      end
    end

    describe 'no_three_repeating_characters_in_a_row_in_password' do
      it 'should return repeatings char if password has three repeating characters in a row' do
        @user.password = "123aaaABC"
        expect(@user.send(:no_three_repeating_characters_in_a_row_in_password)).to eq ["a"]
      end

      it 'should return nil if password has not a repeating characters in a row' do
        @user.password = "123abcABC"
        expect(@user.send(:no_three_repeating_characters_in_a_row_in_password)).to be_nil
      end
    end
  end

  describe '#persisting_result' do
    before(:each) do
      @user = User.new(name: 'username')
    end

    it 'should show success message' do
      @user.password = "QPFJWz1343439"
      @user.save
      expect(@user.persisting_result).to eq "#{@user.name} was successfully saved"
    end

    it 'should show 1 change message' do
      @user.password = "AAAfk1swods"
      @user.save
      expect(@user.persisting_result).to eq "Change 1 character of #{@user.name}'s password"
    end

    it 'should show 4 changes message' do
      @user.password = "Abc123"
      @user.save
      expect(@user.persisting_result).to eq "Change 4 characters of #{@user.name}'s password"
    end

    it 'should show 5 changes message' do
      @user.password = "000aaaBBBccccDDD"
      @user.save
      expect(@user.persisting_result).to eq "Change 5 characters of #{@user.name}'s password"
    end
  end
end
