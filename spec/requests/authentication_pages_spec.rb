require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login" do
    before { visit login_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end
end