class Movie < ApplicationRecord
	validates_presence_of :name, :run_time
	validates_numericality_of :run_time
end
