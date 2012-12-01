require File.dirname(__FILE__) + '/../test_helper'

class DynamicReviewMappingTest < ActiveSupport::TestCase

     test "Assign Reviewers for Individuals" do
          assignment = Assignment.all.select {|a| a.participants.size > 1}[0]
          participants_size = assignment.participants.size
          before_length = ResponseMap.all.length
          assignment.assign_individual_reviewer(1)
          after_length = ResponseMap.all.length
          assert(after_length == (before_length + participants_size * (participants_size - 1)))
     end

     test "Assign Reviewers for Individuals with no participants for the assignment"  do
       assignment = Assignment.new
       assert_raise(RuntimeError){assignment.assign_individual_reviewer(1)}
     end

     test "Assign Reviewers for Individuals to ensure reviewer id is not the same as reviewee id"  do
       assignment = Assignment.first
       assignment.assign_individual_reviewer(1)
       responseMap = ResponseMap.last
       assert_not_equal  responseMap.reviewee_id, responseMap.reviewer_id
     end

     test "No review should take place when there is only one participant for the assignment" do
       assignment = Assignment.all.select {|a| a.participants.size == 1}[0]
       before_length = ResponseMap.all.length
       assignment.assign_individual_reviewer(1)
       after_length = ResponseMap.all.length
       assert(after_length == before_length)
     end

    test "Max reviewers assigned for a team" do
      assignment = Assignment.find(18)
      num_of_teams = assignment.teams.size
      num_of_reviewers = assignment.participants.size
      max_num_of_reviews_possible = num_of_teams * num_of_reviewers
      before_length = ResponseMap.all.length
      assignment.assign_reviewers_for_team(1)
      after_length = ResponseMap.all.length
      assert(after_length - before_length <= max_num_of_reviews_possible)
    end

     test "Reviewers assignment should fail for assignment with no participants" do
       assignment = Assignment.new
       assert_raise(RuntimeError){assignment.assign_reviewers_for_team(1)}
     end

     test "Reviewers assignment should fail for assignment with no teams" do
       #The below assignment has participants but no teams associated with it
       assignment = Assignment.first
       assert_raise(RuntimeError){assignment.assign_reviewers_for_team(1)}
     end
end