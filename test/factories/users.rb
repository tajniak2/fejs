FactoryGirl.define do
  factory :user_0 do
    sequence(:email) { |i| "ktos#{i}@cos.pl" } 
	password "1"
	password_confirmation "1"
  end
  
  factory :user_1 do
    email "ktos@cos.pl"
	password "1"
	password_confirmation "1"
  end
end