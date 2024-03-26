def calc(num1, num2, operator):
    num1 = int(num1)
    num2 = int(num2)
    
    if operator == '+':
        print(num1+num2)
    elif operator == '-':
        print(num1-num2)
    elif operator == '/':
        print(num1/num2)

calculation = ['Please select first number\n', 'Please select second number\n', 'Please select an operator\n']
answers = []

for question in calculation:
    answers.append(input(question))

calc(answers[0], answers[1], answers[2])