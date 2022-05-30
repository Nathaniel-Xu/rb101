def prompt(msg)
  puts "= > #{msg}"
end

def retrieve_info(info_type, result = nil)
  loop do
    prompt("Enter your #{info_type}")
    result = gets.chomp
    if valid_number?(result)
      break
    else
      prompt("Please input a number")
    end
  end
  result.to_f
end

def valid_number?(num)
  num.to_i.to_s == num
end

loop do
  loan_duration_years = retrieve_info("number of years in loan_duration")
  loan_duration_months = retrieve_info("number of months in loan_duration")
  loan_duration = loan_duration_years * 12 + loan_duration_months
  apr = retrieve_info("Annual Percentage Rate") * 0.01
  loan_amount = retrieve_info("loan amount")
  monthly_interest = apr / 12
  monthly_payment = loan_amount * (monthly_interest / (1 - (1 + monthly_interest)**(- loan_duration)))
  prompt("Your monthly payment is #{monthly_payment}")
  prompt("Calculate again? (y/n)")
  answer = gets.chomp
  break unless answer.downcase().start_with?('y')
end

prompt("Thank you for using the Mortgage Calculator")
