require "lib/hamer.rb"
class Test
  include Hamer::Test
  def hello
    Hamer.calculate_weighted_scores_and_reputation(submissions, reviewers)
    submissions.map(&:weighted_score)
    reviewers.map(&:weight)
  end
end

Test.new.hello