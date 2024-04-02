def club_selector(name: str, age: int, has_id: bool = False) -> bool:
    
    """
    club_selector decide if a person can enter the club

    Args:
        name (str): name of the person
        age (int): age of the person
        has_id (bool, optional): If the person has an ID. Defaults to False.

    Returns:
        bool: is Allowed
    """

    isAllowed = is_david(name) and is_an_adult(age) and has_id

    return isAllowed

def is_david(name: str):
    return name.lower() != 'david'

def is_an_adult(age: int):
    return age >= 21

def main() -> None:
    print(club_selector('David', 22, has_id=True)) # should be False
    print(club_selector('Assaf', 22, has_id=True)) # should be True
    print(club_selector('Tomer', 18, has_id=True)) # should be False
    print(club_selector('Avi', 30, has_id=False)) # should be False

if __name__ == '__main__':
    main()