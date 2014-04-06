shared_examples_for "Expression" do
  let(:model) {described_class}

  context "when initializing a new objective" do
    it "sets his name properly" do
      objective = model.new_objective
      expect(objective.name).to be == Model.objective.name
    end
  end

  context "when initializing a new expression" do
    it 'sets source to zero (Proposed)' do
      expression = model.new
      expect(expression.source).to be == Concerns::Expression::SOURCES.proposed()
    end
  end

  describe "when getting status" do
    context "is to be approved if any approval role approved yet" do
      it "get to be approved because have two approval roles without approve" do
        mock_expression_model approval_roles: [1, 0]
        expression = create :objective
        expect(expression.status).to be == described_class::STATUS.to_be_approved()
      end
    end

    context "is partial approval if any approval roles has been approved, but not all" do
      it "gets partial approval because have three approval roles and two of them have approves" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        create :approval, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, expression: expression, user_role: create(:user_role, role_id: 1)

        expect(expression.status).to be == described_class::STATUS.partial_approval()
      end
    end

    context "is approved if all approval roles has been approved" do
      it "gets approved because every three approval roles has been approved" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        create :approval, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, expression: expression, user_role: create(:user_role, role_id: 1)
        create :approval, expression: expression, user_role: create(:user_role, role_id: 2)

        expect(expression.status).to be == described_class::STATUS.approved()
      end

      it "gets approved because have no approval roles" do
        mock_expression_model approval_roles: []
        expression = create :objective
        expect(expression.status).to be == described_class::STATUS.approved()
      end
    end

    context "is partial rejected if have any approval roles has rejected, but not all" do
      it "gets partial rejected because two of three approval roles has rejected" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 1)

        expect(expression.status).to be == described_class::STATUS.partial_rejection
      end

      it "gets partial rejected because two of three approval roles has rejected and the other approved" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 1)
        create :approval, positive: true, expression: expression, user_role: create(:user_role, role_id: 2)

        expect(expression.status).to be == described_class::STATUS.partial_rejection
      end
    end

    context "is rejected if all approval roles has rejected" do
      it "gets rejected because all three approval roles rejected" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 1)
        create :approval, positive: false, expression: expression, user_role: create(:user_role, role_id: 2)

        expect(expression.status).to be == described_class::STATUS.rejected
      end
    end
  end

  describe "when reseting itself" do
    context "destroy all the approvals" do
      it "destroy three approvals because expression was approved three times" do
        mock_expression_model approval_roles: [2, 1, 0]
        expression = create :objective

        approvals = [
          create(:approval, expression: expression, user_role: create(:user_role, role_id: 0)),
          create(:approval, expression: expression, user_role: create(:user_role, role_id: 1)),
          create(:approval, expression: expression, user_role: create(:user_role, role_id: 2))
        ]

        expression.reset

        expect(Approval.exists?(approvals[0].id)).to be == false
        expect(Approval.exists?(approvals[1].id)).to be == false
        expect(Approval.exists?(approvals[2].id)).to be == false
        expect(expression.approvals).to be_empty
      end
    end

    context "destroys approvals of all descendents" do
      it "keeps expression siblings approvals but deletes all approvals of 2 strategies and 4 tactics that are group descendents" do
        mock_expression_model approval_roles: [2, 1, 0]

        tactics_groups = create_list(:tactic_group, 4)

        strategies_groups = [
          create(:strategy_group, childs: tactics_groups[0..1]),
          create(:strategy_group, childs: tactics_groups[2..3])
        ]

        objective_group = create :objective_group,
          childs: strategies_groups

        objective_group.text_expressions << create(:objective, group: objective_group)

        (tactics_groups + strategies_groups + [objective_group]).each do |group|
          group.expressions.each do |exp|
            create :approval, expression: exp, user_role: create(:user_role, role_id: 0)
            create :approval, expression: exp, user_role: create(:user_role, role_id: 1)
          end
        end

        objective_expression1 = objective_group.text_expressions[0]
        objective_expression2 = objective_group.text_expressions[1]

        objective_expression1.reset
        expect(Approval.all.to_a).to be == objective_expression2.approvals.to_a
      end
    end
  end
end
