require 'spec_helper'

describe User do
  it "should be valid from factory" do
    u = Factory(:user)
    u.should be_valid
  end
  it "should have a provider" do
    u = Factory.build(:user, :provider => nil)
    u.should_not be_valid
  end
  it "should have an uid" do
    u = Factory.build(:user, :uid => nil)
    u.should_not be_valid
  end
  it "should not have duplicate provider and uid" do
    u = Factory.build(:user, :provider => "twitter", :uid => "123456")
    u.should be_valid
    u.save
    u = Factory.build(:user, :provider => "twitter", :uid => "123456")
    u.should_not be_valid
  end
  it "should allow empty email" do
    u = Factory.build(:user)
    u.email = ""
    u.should be_valid
    u.email = nil
    u.should be_valid
  end
  it "should check email format" do
    u = Factory.build(:user)
    u.email = "foo"
    u.should_not be_valid
    u.email = "foo@bar"
    u.should_not be_valid
    u.email = "foo@bar.com"
    u.should be_valid
  end
  it "should not be valid with a bio longer than 140 characters" do
    u = Factory.build(:user)
    u.bio = "a".center(139)
    u.should be_valid
    u.bio = "a".center(140)
    u.should be_valid
    u.bio = "a".center(141)
    u.should_not be_valid
  end
  it "should create a new user receiving a omniauth hash" do
    auth = {
      'provider' => "twitter",
      'uid' => "foobar",
      'user_info' => {
        'name' => "Foo bar",
        'nickname' => "foobar",
        'description' => "Foo bar's bio".ljust(200),
        'image' => "user.png"
      }
    }
    u = User.create_with_omniauth(auth)
    u.should be_valid
    u.provider.should == auth['provider']
    u.uid.should == auth['uid']
    u.name.should == auth['user_info']['name']
    u.nickname.should == auth['user_info']['nickname']
    u.bio.should == auth['user_info']['description'][0..139]
    u.image_url.should == auth['user_info']['image']
  end
  it "should have a display_name that shows the name, nickname or 'Sem nome'" do
    u = Factory(:user, :name => "Name")
    u.display_name.should == "Name"
    u = Factory(:user, :name => nil, :nickname => "Nickname")
    u.display_name.should == "Nickname"
    u = Factory(:user, :name => nil, :nickname => nil)
    u.display_name.should == "Sem nome"
  end
  it "should have a display_image that shows the user's image or user.png" do
    u = Factory(:user, :image_url => "image.png")
    u.display_image.should == "image.png"
    u = Factory(:user, :image_url => nil)
    u.display_image.should == "user.png"
  end
end

