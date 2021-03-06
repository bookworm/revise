require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe 'Account Model' do
  should 'save an account model instance' do
    account = FactoryGirl.build(:account)
    assert account.save 

    assert account.encrypted_password
  end    

  should 'destroy an account' do
    account = FactoryGirl.create(:account)
    assert account.destroy
  end 

  should 'update an account' do
    account = FactoryGirl.create(:account)
    assert account.update_attributes!(:name => 'Updated, Guy')

    account = Account.find_by_id(account.id)
    assert account.first_name == 'Updated'
  end 

 should 'confirm an account' do
   account = FactoryGirl.create(:account)

   assert !account.confirmed?

   account = Account.confirm_by_token(account.confirmation_token)
   assert account
   assert_empty account.errors
 end

  should 'reset a password' do
    account = FactoryGirl.create(:account)
    account.send_reset_password_instructions

    account = Account.reset_password_by_token({:password              => 'newpass', 
                                               :password_confirmation => 'newpass', 
                                               :reset_password_token  => account.reset_password_token})

    assert account
    assert_empty account.errors
  end
end
