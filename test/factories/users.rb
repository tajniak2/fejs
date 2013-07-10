FactoryGirl.define do
  factory :user_0, :class => User do
    sequence(:email) { |i| "ktos#{i}@cos.pl" } 
	password "1"
	password_confirmation "1"
  end
  
  factory :user_1, :class => User do
    email "ktos@cos.pl"
	password "1"
	password_confirmation "1"
  end
end