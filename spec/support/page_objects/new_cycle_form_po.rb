module PageObjects
  class NewCycleFormPO
    def initialize(user_knowledge, element)
      @user = user_knowledge
      @form = element
    end

    def fill_from(datetime)
      fill_datetime_with_preffix(datetime, "from")
    end

    def fill_to(datetime)
      fill_datetime_with_preffix(datetime, "to")
    end

    def fill_objectives(objectives)
      delete_buttons = @form.all ".objectives-inputs li button"
      delete_buttons.each(&:click)

      add_button = @form.find ".add-objective-btn"
      objectives.each do |obj|
        add_button.click
        inputs = @form.all ".objectives-inputs li input"
        inputs.last.set obj.text
      end
    end

    def fill_priorities(priorities_text)
      @form.fill_in "cycle_priorities", with: priorities_text
    end

    def number
      @form.find("input.disabled_cycle_number").value.to_i
    end

    def from
      if @form.has_css?(".disabled_cycle_from")
        get_disabled_datetime_with_preffix("from")
      else
        get_datetime_with_preffix("from")
      end
    end

    def to
      get_datetime_with_preffix("to")
    end

    def objectives
      inputs = @form.all ".objectives-inputs li input"
      inputs.map{|input| TextExpression.new_objective(text: input.value)}
    end

    def priorities
      objectives_texts = @form.find("#cycle_priorities").value
    end

    def submit
      @form.click_button "Create Period"
      wait_until{@user.session.current_path.include? "confirm"}
      CycleConfirmPO.new(@user)
    end

    def element
      @form
    end

  private
    def fill_datetime_with_preffix(datetime, preffix)
      id_template = "cycle_#{preffix}_%di"
      @form.select datetime.year, from: sprintf(id_template, 1)
      @form.select DateTime::MONTHNAMES[datetime.month], from: sprintf(id_template, 2)
      @form.select datetime.day, from: sprintf(id_template, 3)
      @form.select sprintf("%.2d", datetime.hour), from: sprintf(id_template, 4)
      @form.select sprintf("%.2d", datetime.minute), from: sprintf(id_template, 5)
    end

    def get_datetime_with_preffix(preffix)
      template = "select[name='cycle\[#{preffix}(%di)\]']"
      year = @form.find(sprintf(template, 1)).value.to_i
      month = @form.find(sprintf(template, 2)).value.to_i
      day = @form.find(sprintf(template, 3)).value.to_i
      hour = @form.find(sprintf(template, 4)).value.to_i
      minute = @form.find(sprintf(template, 5)).value.to_i

      Time.new(year, month, day, hour, minute).to_datetime
    end

    def get_disabled_datetime_with_preffix(preffix)
      template = "select[name='cycle\[#{preffix}(%di)\]'].disabled_cycle_#{preffix}"
      year = @form.find(sprintf(template, 1)).value.to_i
      month = @form.find(sprintf(template, 2)).value.to_i
      day = @form.find(sprintf(template, 3)).value.to_i
      hour = @form.find(sprintf(template, 4)).value.to_i
      minute = @form.find(sprintf(template, 5)).value.to_i

      Time.new(year, month, day, hour, minute).to_datetime
    end
  end
end

