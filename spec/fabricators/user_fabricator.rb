Fabricator(:user) do 
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  name { Faker::Name.name }
  admin false
end

Fabricator(:admin, from: :user) do
  admin true
end