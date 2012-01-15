ActiveAdmin.register User do
  controller do
    defaults :finder => :find_by_login
  end  
end
