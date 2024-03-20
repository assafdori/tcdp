print(f"Hello and welcome to Assaf's Makolet!")
name = input(f'Nice to meet you, what is your name?\n')
budget =  int(input(f'It is a pleasure to meet you {name}, what is your budget for today?\n'))
if budget == 0:
    print(f"That is unfortunate. Here's a glass of water.")
elif budget >= 1:
    print(f"I'm glad your budget is {budget}NIS, please enjoy shopping!")
shopping_cart = ["Apples", "Milk", "Bread", "Eggs", "Cheese"]

cart_price = 0

for item in shopping_cart:
    cart_price += int(input(f'What is the price for the {item} you got?\n'))

print(f"The total is: {cart_price}NIS")

if cart_price > budget:
    print(f"You don't have enough mullah.")
elif cart_price < budget:
    print(f"Thanks for shopping at Assaf's Makolet! You have received {budget - cart_price}NIS in change.")