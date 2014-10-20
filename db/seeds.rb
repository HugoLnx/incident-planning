Company.find_or_create_by(name: "Admin", id: Company::ADMIN_ID)
User.where("email in ('hugolnx@gmail.com', 'malencar@tecgraf.puc-rio.br', 'malencar@inf.puc-rio.br', 'marcus.4biz@gmail.com')")
  .update_all(company_id: Company::ADMIN_ID)
