# frozen_string_literal: true

describe User do
  before(:each) { @user = User.new(email: 'users@example.com') }

  subject { @user }

  it { should respond_to(:email) }

  it '#email returns a string' do
    expect(@user.email).to match 'users@example.com'
  end
end
