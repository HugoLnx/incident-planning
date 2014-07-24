module Publish
  class GroupMessagesIterator
    def initialize(messages)
      @messages = messages
      @marks = {}
      @messages.each{|key,_| @marks[key] = Hash.new([])}
    end

    def on(exp_id)
      messages = []
      @messages.each do |exps_ids, exps_messages|
        if exps_ids.include? exp_id
          messages += exps_messages
        end
      end
      messages
    end

    def include?(exp_id)
      @messages.each do |exps_ids, exps_messages|
        if exps_ids.include? exp_id
          return true
        end
      end
      return false
    end

    def mark_for_group(exp_id, group_id)
      @marks.each_pair do |exps_ids, marks|
        if exps_ids.include? exp_id
          marks[group_id] << exp_id
        end
      end
    end

    def one_marked_on_group?(exp_id, group_id)
      @marks.each_pair do |exps_ids, marks|
        if exps_ids.include?(exp_id) && marks[group_id].size == 1
          return true
        end
      end
      return false
    end

    def all_marked_on_group?(exp_id, group_id)
      @marks.each_pair do |exps_ids, marks|
        if exps_ids.include?(exp_id) && exps_ids.size == marks[group_id].size
          return true
        end
      end
      return false
    end
  end
end
