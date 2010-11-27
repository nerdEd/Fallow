namespace :fallow do
  desc "finish any furrows which are past their duration"
  task :finish_due => [:environment] do
    Furrow.due_for_completion.map(&:finish)
  end
end
