# require "#{Dir.pwd}/lib/generator.rb"

puts 'Welcome to the Payslip Generator'

loop do
  puts "Please enter 1 to generate payslips or 2 to exit."
  input = gets.chomp

  abort("Exiting...Goodbye!") if input == '2'

  while not ['1'].include?(input)
    puts "That's an invalid entry"
    puts "Please enter 1 to generate payslips or 2 to exit."
    input = gets.chomp

    abort("Exiting...Goodbye!") if input == '2'
  end


  puts 'Please save your csv input file in the Input folder then click enter'
  generator = PayslipGenerator.new
  generator.run

end
