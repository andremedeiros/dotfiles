#!/usr/bin/env ruby
require 'irb/completion'

IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"

IRB.conf[:PROMPT_MODE] = :SIMPLE

%w[pp].each do |gem|
  begin
    require gem
  rescue LoadError
    # OMNOMNOM I LOVE EXCEPTIONS
  end
end
