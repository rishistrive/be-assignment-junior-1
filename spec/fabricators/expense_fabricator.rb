Fabricator(:expense) do
  user_id { Fabricate(:user).id }
  amount { 1.5 }
  paid_by { Fabricate(:user).id }
  description { "MyText" }
  tax { 1.5 }
  tip { 1.5 }
  created_at { "2024-05-01 18:14:15" }
  updated_at { "2024-05-01 18:14:15" }
end