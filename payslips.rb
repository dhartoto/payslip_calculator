require "./lib/generator"

puts 'Welcome to the Payslip Generator'

puts "Please save 'employee_details.csv' into the 'input' folder."
puts "Enter 1 to generate payslips or 2 to exit."
input = gets.chomp

abort("Exiting...Goodbye!") if input == '2'

while not ['1'].include?(input)
  puts "That's an invalid entry"
  puts "Please enter 1 to generate payslips or 2 to exit."
  input = gets.chomp

  abort("Exiting...Goodbye!") if input == '2'
end

generator = Generator.new
generator.run
