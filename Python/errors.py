myList = ['a', 'b', 'c']

index = 0

while True:
    try:
        item = input('Enter index or q to quit\n')

        if item.lower() == 'q':
            break
        item = int(item)
        print(myList[item])
    
    except IndexError:
        print(f'The range is 0 - {len(myList) - 1}')
    
    except ValueError:
        print(f'Please enter a number.')

print("Goodbye.")