module PageObjects
  class NewCycleFormPO
    def initialize(user_knowledge, element)
      @user = user_knowledge
      @form = element
    end

    def fill_number(number)
      @form.fill_in "cycle_number", with: number.to_s
    end

    def fill_from(datetime)
      fill_datetime_with_preffix(datetime, "cycle_from")
    end

    def fill_to(datetime)
      fill_datetime_with_preffix(datetime, "cycle_to")
    end

    def fill_objectives(objectives)
      @form.fill_in "cycle_objectives_text", with: objectives.map(&:text).join("\n")
    end

    def fill_priorities(priorities_text)
      @form.fill_in "cycle_priorities", with: priorities_text
    end

    def number
      @form.find("#cycle_number").value.to_i
    end

    def from
      get_datetime_with_preffix("cycle_from")
    end

    def to
      get_datetime_with_preffix("cycle_to")
    end

    def objectives
      objectives_texts = @form.find("#cycle_objectives_text").value
      objectives_texts.split("\n").map{|text| TextExpression.new_objective(text: text)}
    end

    def priorities
      objectives_texts = @form.find("#cycle_priorities").value
    end

    def submit
      @form.click_button "Create Cycle"
      wait_until{@user.session.current_path.include? "confirm"}
      CycleConfirmPO.new(@user)
    end

    def element
      @form
    end

  private
    def fill_datetime_with_preffix(datetime, preffix)
      @form.select datetime.year, from: "#{preffix}_1i"
      @form.select DateTime::MONTHNAMES[datetime.month], from: "#{preffix}_2i"
      @form.select datetime.day, from: "#{preffix}_3i"
      @form.select sprintf("%.2d", datetime.hour), from: "#{preffix}_4i"
      @form.select sprintf("%.2d", datetime.minute), from: "#{preffix}_5i"
    end

    def get_datetime_with_preffix(preffix)
      year = @form.find("##{preffix}_1i").value.to_i
      month = @form.find("##{preffix}_2i").value.to_i
      day = @form.find("##{preffix}_3i").value.to_i
      hour = @form.find("##{preffix}_4i").value.to_i
      minute = @form.find("##{preffix}_5i").value.to_i

      DateTime.new(year, month, day, hour, minute)
    end
  end
end

