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

  describe 'errors size' do
    before(:each) do
      @user = User.new(name: 'username')
    end

    it 'should not have any errors for "QPFJWz1343439"' do
      @user.password = 'QPFJWz1343439'
      @user.valid?
      expect(@user.errors).to be_empty
    end

    it 'should have 1 error for "AAAfk1swods"' do
      @user.password = 'AAAfk1swods'
      @user.valid?
      expect(@user.errors.size).to eq 1
    end

    it 'should have 1 error "Abc123"' do
      @user.password = 'Abc123'
      @user.valid?
      expect(@user.errors.size).to eq 1
    end

    it 'should have 5 errors "000aaaBBBccccDDD"' do
      @user.password = '000aaaBBBccccDDD'
      @user.valid?
      expect(@user.errors.size).to eq 5
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
end
