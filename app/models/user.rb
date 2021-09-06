class User < ApplicationRecord
  has_secure_password

  validates :name, presence: true
  validates :password, presence: true

  validate :password_length
  validate :at_least_one_lowercase_character_in_password
  validate :at_least_one_uppercase_character_in_password
  validate :at_least_one_digit_in_password
  validate :no_three_repeating_characters_in_a_row_in_password

  def persist_result
    if persisted?
      "#{name} was successfully saved"
    else
      "Change #{errors.size} #{'character'.pluralize(errors.size)} of #{name}'s password"
    end
  end

  private

  def password_length
    return false if password.nil?
    if !password.length.between?(10,16)
      if password.length < 10
        errors_to_add = 10 - password.length
      else
        errors_to_add = password.length - 16
      end

      # Not the best message, might need to refactor this method
      errors_to_add.times { errors.add(:password, "needs to insert/delete chars") }
    end
  end

  def at_least_one_lowercase_character_in_password
    if !/[[:lower:]]/.match?(password)
      errors.add(:password, "doesn't contains a lowercase char")
    end
  end

  def at_least_one_uppercase_character_in_password
    if !/[[:upper:]]/.match?(password)
      errors.add(:password, "doesn't contains an uppercase char")
    end
  end

  def at_least_one_digit_in_password
    if !/[[:digit:]]/.match?(password)
      errors.add(:password, "doesn't contains a digit")
    end
  end

  def no_three_repeating_characters_in_a_row_in_password
    return false if password.nil?
    repeated_chars = password.scan(/((.)\2{2,})/).map(&:last)
    if !repeated_chars.empty?
      repeated_chars.each do |char|
        errors.add(:password, "has '#{char}' character repeated more than 3 times in a row")
      end
    end
  end
end
