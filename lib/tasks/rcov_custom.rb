desc  "Custom rcov"
RSpec::Core::RakeTask.new(:rcov_custom) do |t|
  t.rcov = true
  t.rcov_opts = %w{--exclude gems\/,spec\/ -T}
end
