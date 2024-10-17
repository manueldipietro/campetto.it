require "test_helper"

class PartnerTest < ActiveSupport::TestCase
  
  #The following tests were generated with the help of ChatGPT
  
  def setup
    @partner = Partner.new(
      name: "Mario", 
      surname: "Rossi", 
      email: "mario.rossi@example.com",
      gender: "M", 
      birthday: "15-04-1985", 
      mobile: "+123-1234567890",
      password: "foobar",
      password_confirmation: "foobar"
    )
  end

  # Test di validazione per 'name'
  test "name should be present" do
    @partner.name = ""
    assert_not @partner.valid?, "Partner should be invalid without a name"
  end
  test "name should not be too short" do
    @partner.name = "A"
    assert_not @partner.valid?, "Partner name should have at least 2 characters"
  end
  test "name should not be too long" do
    @partner.name = "A" * 51
    assert_not @partner.valid?, "Partner name should not have more than 50 characters"
  end

  # Test di validazione per 'surname'
  test "surname should be present" do
    @partner.surname = ""
    assert_not @partner.valid?, "Partner should be invalid without a surname"
  end
  test "surname should not be too short" do
    @partner.surname = "B"
    assert_not @partner.valid?, "Partner surname should have at least 2 characters"
  end
  test "surname should not be too long" do
    @partner.surname = "B" * 51
    assert_not @partner.valid?, "Partner surname should not have more than 50 characters"
  end

  # Test di validazione per 'email'
  test "email should be present" do
    @partner.email = ""
    assert_not @partner.valid?, "Partner should be invalid without an email"
  end
  test "email should be unique" do
    duplicate_partner = @partner.dup
    @partner.save
    assert_not duplicate_partner.valid?, "Partner should be invalid with a duplicate email"
  end
  test "email should have valid format" do
    invalid_emails = %w[partner_at_email.com partner@email partner.email.com]
    invalid_emails.each do |invalid_email|
      @partner.email = invalid_email
      assert_not @partner.valid?, "#{invalid_email} should be invalid"
    end
  end
  test "email should accept valid format" do
    valid_emails = %w[partner@email.com PARTNER@foo.COM first.last@foo.jp]
    valid_emails.each do |valid_email|
      @partner.email = valid_email
      assert @partner.valid?, "#{valid_email} should be valid"
    end
  end

  # Test di validazione per 'gender'
  test "gender can be optional" do
    @partner.gender = nil
    assert @partner.valid?, "Partner should be valid without a gender"
  end
  test "gender should be m, f, or u if present" do
    valid_genders = ["m", "f", "u"]
    valid_genders.each do |valid_gender|
      @partner.gender = valid_gender
      assert @partner.valid?, "#{valid_gender} should be valid"
    end
  end
  test "gender should be invalid if not m, f, or u" do
    @partner.gender = "X"
    assert_not @partner.valid?, "Partner should be invalid with gender not being m, f, or u"
  end

  # Test di validazione per 'birthday'
  test "birthday should be present" do
    @partner.birthday = ""
    assert_not @partner.valid?, "Partner should be invalid without a birthday"
  end
  test "birthday should be in valid DD-MM-YYYY format" do
    invalid_dates = %w[1985-04-15 15/04/1985 04-15-1985]
    invalid_dates.each do |invalid_date|
      @partner.birthday = invalid_date
      assert_not @partner.valid?, "#{invalid_date} should be invalid"
    end
  end
  test "birthday should accept valid format" do
    @partner.birthday = "15-04-1985"
    assert @partner.valid?, "Partner should be valid with birthday in DD-MM-YYYY format"
  end

  # Test di validazione per 'mobile'
  test "mobile should be present" do
    @partner.mobile = ""
    assert_not @partner.valid?, "Partner should be invalid without a mobile"
  end
  test "mobile should be in valid format" do
    invalid_mobiles = %w[1234567890 +1234567890 +1234-234343 123-12345 +123-123456789012345]
    invalid_mobiles.each do |invalid_mobile|
      @partner.mobile = invalid_mobile
      assert_not @partner.valid?, "#{invalid_mobile} should be invalid"
    end
  end
  test "mobile should accept valid format" do
    @partner.mobile = "+123-1234567890"
    assert @partner.valid?, "Partner should be valid with a correct mobile format"
  end
  
  #Test di validazione per 'password'
  test "password should have a minimum length" do
    @partner.password = @partner.password_confirmation = "a" * 5
    assert_not @partner.valid?, "Partner password should have at least 6 characters"
  end

end
