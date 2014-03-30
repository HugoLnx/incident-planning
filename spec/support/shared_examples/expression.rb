shared_examples_for "Expression" do
  let(:model) {described_class}

  context "when initializing a new objective" do
    it "sets his name properly" do
      objective = model.new_objective
      expect(objective.name).to be == Model.objective.name
    end
  end

  context "when verifying if permits role approval" do
    before :each do
      mock_expression_model approval_roles: [0, 1]
      @expression = build :text_expression
    end

    context "returns true" do
      specify 'when the role is included in expression approval roles' do
        expect(@expression.permits_role_approval?(0)).to  be == true
        expect(@expression.permits_role_approval?(1)).to  be == true
      end

      specify 'when one of the roles is included in expression approval roles' do
        expect(@expression.permits_role_approval?([0, 1])).to  be == true
        expect(@expression.permits_role_approval?([0, 2])).to  be == true
        expect(@expression.permits_role_approval?([1, 4])).to  be == true
      end
    end

    context "returns false" do
      specify "if role id isn't included in expression approval roles" do
        expect(@expression.permits_role_approval?(3)).to  be == false
      end

      specify "if all role ids aren't included in expression approval roles" do
        expect(@expression.permits_role_approval?([3, 5])).to  be == false
      end
    end
  end

  describe "when verifying if already have needed role approval" do
    context "verifies if all of roles passed that have permission to approve already did it" do
      it "returns true because the unique role passed that have permission already approved" do
        mock_expression_model approval_roles: [0]
        expression = build :objective

        create :approval, expression: expression, user_role: create(:user_role, role_id: 0)
        
        expect(expression.already_had_needed_role_approval?([0, 1])).to  be == true
      end

      it "returns true because all roles passed have permission and already approved" do
        mock_expression_model approval_roles: [0, 1]
        expression = build :objective

        create :approval, expression: expression, user_role: create(:user_role, role_id: 0)
        create :approval, expression: expression, user_role: create(:user_role, role_id: 1)
        
        expect(expression.already_had_needed_role_approval?([0, 1])).to  be == true
      end

      it "returns false because roles passed was an empty array" do
        expression = build :objective
        expect(expression.already_had_needed_role_approval?([])).to  be == false
      end

      it "returns false because any role passed have permission" do
        mock_expression_model approval_roles: [0, 1]
        expression = build :objective
        expect(expression.already_had_needed_role_approval?([2,3])).to  be == false
      end

      it "returns false because the all roles passed have permission and doesn't approved yet" do
        mock_expression_model approval_roles: [0, 1]
        expression = build :objective
        
        expect(expression.already_had_needed_role_approval?([0, 1])).to  be == false
      end

      it "returns false because one of the roles passed have permission and doesn't approved yet" do
        mock_expression_model approval_roles: [0, 1]
        expression = build :objective

        create :approval, expression: expression, user_role: create(:user_role, role_id: 0)
        
        expect(expression.already_had_needed_role_approval?([0, 1])).to  be == false
      end
    end
  end

  context "when initializing a new expression" do
    it 'sets source to zero (Proposed)' do
      expression = model.new
      expect(expression.source).to be == Concerns::Expression::SOURCES.proposed()
    end
  end

  describe "when getting the roles missing approvement" do
    context "gets all approval roles if expression have no approvals yet" do
      it "gets two roles from expression model approval roles" do
        roles_ids = [0, 1]
        mock_expression_model approval_roles: roles_ids
        expression = build :text_expression

        expect(expression.roles_missing_approvement).to be == roles_ids
      end
    end

    context "doesn't include roles that already approved that expression" do
      it "ignore two approving roles from expression model approval roles" do
        mock_expression_model approval_roles: [0, 1, 2]
        expression = create :objective

        create :approval, user_role: create(:user_role, role_id: 0), expression: expression
        create :approval, user_role: create(:user_role, role_id: 1), expression: expression

        expect(expression.roles_missing_approvement).to be == [2]
      end
    end
  end

  describe "when getting the roles needed to approve" do
    context "gets all approval roles from expression model" do
      it 'gets two roles because expression model approval have two roles' do
        mock_expression_model approval_roles: [0, 1]
        expression = create :objective

        expect(expression.roles_needed_to_approve).to be == [0, 1]
      end

      it 'gets two roles even they have approved the expression' do
        mock_expression_model approval_roles: [0, 1]
        expression = create :objective

        create :approval, user_role: create(:user_role, role_id: 0), expression: expression
        create :approval, user_role: create(:user_role, role_id: 1), expression: expression

        expect(expression.roles_needed_to_approve).to be == [0, 1]
      end
    end
  end

  describe "when getting user that approved as a specific role" do
    context "return user if any user approved as the role" do
      it "gets user because he already approved that expression as the role passed" do
        user = create :user
        user_role = create(:user_role, user: user, role_id: 0)
        user.reload
        expression = create :objective

        create :approval, user_role: user_role, expression: expression

        expect(expression.user_that_approved_as(0)).to be == user
      end
    end

    context "return nil if none user approved as the role" do
      it "gets nil because nobody approved that expression yet" do
        expression = create :objective

        expect(expression.user_that_approved_as(0)).to be == nil
      end

      it "gets nil because nobody with the passed role approved that expression" do
        expression = create :objective

        user = create :user
        user_role = create(:user_role, user: user, role_id: 0)
        user.reload
        expression = create :objective

        create :approval, user_role: user_role, expression: expression

        expect(expression.user_that_approved_as(1)).to be == nil
      end
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
