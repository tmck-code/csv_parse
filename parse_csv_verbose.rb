#! /usr/bin/ruby

# The program takes a csv file and parses it line by line,
# printing a summary to stdout
#
# Author::    Thomas McKeesick  (mailto:tmck01@gmail.com)
# Copyright:: (c) 2016 Thomas McKeesick
# License::   MIT License

# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
require 'bigdecimal'


#This extends the String class to test if string is a number
class String
  def is_number?
    self.to_f.to_s == self.to_s || self.to_i.to_s == self.to_s
  end
end

# This class contains methods for parsing a CSV file, retrieving information
# about columns and maximum values, then prints all of the data to stdout
class ParseCSV

  @@filename = ""
  @@titles = Array.new()
  @@max_vals = Array.new()

  def initialize(file)
    @filename = file
    puts ("Initialized filename : #{@filename} \n")
    @titles = get_column_titles(@filename)
    puts "Number of columns    : #{@titles.length}"
    puts "initialized titles   : #@titles"
    @max_vals = Array.new(@titles.length)
  end

  #Function to test if an item is numeric
  def to_numeric(obj)
    num = BigDecimal.new(obj.to_s)
    if num.frac == 0
      num.to_i
    else
      num.to_f
    end
  end

  # Get the column names from the data
  def get_column_titles(filename)
    head = File.open(filename, &:readline)
    head = head.rstrip!
    return head.split(',')
  end

  # Compares the elements in the current line against the current
  # maximum, then updates the max_vals array and returns it
  def check_max_values(line_array, line_num)
    print_new_line = false
    line_array.each_with_index { |col, index|
      if index >= @max_vals.length; return @max_vals; end

      if !(col.nil?) && col.is_number?; col = to_numeric(col)
        if @max_vals[index].nil?
          @max_vals[index] = col
        elsif col > to_numeric(@max_vals[index])
          print "New max [#{@titles[index]}] @line #{line_num}: #{line_array}\n"
          @max_vals[index] = col
          print_new_line = true
        end
      end
    }
    if print_new_line; puts; end
  end

  # Print out the contents of the current line
  def print_info(line_array)
    col_num = line_array.length
    puts "#{line_array}\nnum_cols: #{col_num}"
    @titles.each_with_index { |val, index|
      puts "#{val} => #{line_array[index]}"
    }
    puts "\n"
  end

  # Reads in the CSV file line by line and
  # - Prints the seperated contents of the line
  # - Compares elements to find the maximum number values in the file
  # - Returns the maximum column values in an array
  def parse_file()
    max_vals = Array.new(@@titles.length)
    f = File.open(@filename, "r"); puts "\nFILE OPENED: #{@filename}"; f.gets
    #Format line, print information and check against the max vals
    line_num = 1
    f.each_line { |line|
      line = line.rstrip!
      line_array = line.split(/,/)
      puts "@line #{line_num} -------------------------------------------------"
      print_info(line_array)
      check_max_values(line_array, line_num)
      line_num += 1
    }
    return @max_vals
  end
end

###########################################################
# Execution and argument error checking

def check_args()
  if ARGV.length != 1
    abort("ERROR: Incorrect number of arguments\n"\
      "Usage: ruby parse_and_write_copy.rb <input_file>  > output_file.txt\n"\
      "*********IT IS RECOMMENDED TO PIPE THIS TO AN OUTPUT FILE*********")
  end

  infile = ARGV[0]

  unless File.file?(infile)
    abort("ERROR: Input file does not exist\n"\
      "<input_file>: #{infile}\n")
  end
end

###########################################################
# EXECUTION CODE

check_args()
infile = ARGV[0]

obj = ParseCSV. new(infile)
# Titles and max vals are returned and stored in case further manipulation
# is needed
titles = obj.get_column_titles(infile)
max_vals = obj.parse_file()

puts "===   maxs   ==="
titles.each_with_index { |v, i|
  unless max_vals[i].nil?
  puts "#{v}: #{max_vals[i]}"
  else
    puts "#{v}: n/a"
  end
}
