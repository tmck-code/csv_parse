#! /usr/bin/ruby

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

class File
  def self.copy_by_buffer(infile, outfile)
    File.open(infile, "rb") { |input|
      File.open(outfile, "wb") { |output|
        while buffer = input.read(4096)
          output.write(buffer)
        end
      }
    }
  end
end

def check_args()
  if ARGV.length != 2
    abort("ERROR: Incorrect number of arguments\n"\
      "Usage: ruby parse_and_write_copy.rb <input_file> <output_file>")
  end

  if ARGV[0] == ARGV[1]
    abort("ERROR: Input and output files must be different\n"\
      "<input_file>: #{ARGV[0]}\n<output_file>: #{ARGV[1]}")
  end

  infile = ARGV[0]
  outfile = ARGV[1]

  unless File.file?(infile)
    abort("ERROR: Input file does not exist\n"\
      "<input_file>: #{ARGV[0]}")
  end

  if File.file?(outfile)
    abort("ERROR: Output file already exists, not overwriting for safety\n"\
      "<output_file>: #{ARGV[1]}")
  end
end

check_args()
File.copy_by_buffer ARGV[0], ARGV[1]
