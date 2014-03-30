def mock_expression_model(approval_roles: nil)
  expression_model = build :expression, approval_roles: approval_roles
  allow(Model).to receive(:find_expression_by_name).and_return(expression_model)
end
