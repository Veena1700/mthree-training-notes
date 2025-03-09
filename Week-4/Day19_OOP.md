# Python Object-Oriented Programming: From Basic to Advanced

## Introduction
This comprehensive guide covers Python's OOP features with examples, analogies, and detailed comments. Each section builds upon the previous one, progressing from basic to advanced concepts.

---

## Section 1: Basic Class Definition and Objects

### Analogy:
Think of a class as a blueprint for a house. The blueprint defines what the house will have (attributes) and what can be done in it (methods). An object is an actual house built from that blueprint.

### Example: Defining a Simple Class
```python
class Dog:
    """A simple class representing a dog."""
    species = "Canis familiaris"

    def __init__(self, name, age):
        self.name = name  # Instance attribute
        self.age = age

    def bark(self):
        return f"{self.name} says Woof!"

    def get_info(self):
        return f"{self.name} is {self.age} years old."
```

### Creating Objects
```python
fido = Dog("Fido", 3)
bella = Dog("Bella", 5)
print(fido.bark())  # Output: Fido says Woof!
print(bella.get_info())  # Output: Bella is 5 years old.
```

---

## Section 2: Inheritance

### Analogy:
Inheritance is like genetic inheritance. A child inherits traits from their parents but may also have unique characteristics. Similarly, a subclass inherits attributes and methods from its parent class but can also have its own unique attributes and methods.

### Example: Defining a Parent and Child Class
```python
class Pet:
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def speak(self):
        return "Some generic pet sound"

    def __str__(self):
        return f"{self.name}, age {self.age}"

class Cat(Pet):
    species = "Felis catus"

    def __init__(self, name, age, color):
        super().__init__(name, age)
        self.color = color

    def speak(self):
        return f"{self.name} says Meow!"

    def purr(self):
        return f"{self.name} purrs contentedly."
```

### Creating a Subclass Object
```python
whiskers = Cat("Whiskers", 4, "gray")
print(whiskers.speak())  # Output: Whiskers says Meow!
print(whiskers.purr())   # Output: Whiskers purrs contentedly.
```

---

## Section 3: Encapsulation

### Analogy:
Encapsulation is like a car's engine covered by a hood. Users don't need to know how the engine works internally; they just use the steering wheel, pedals, etc. (the public interface). Similarly, objects can hide their internal state and require other objects to interact with them through their public methods.

### Example: Private and Protected Attributes
```python
class BankAccount:
    def __init__(self, owner, initial_balance=0):
        self.owner = owner
        self.__balance = initial_balance  # Private attribute
        self._transaction_count = 0  # Protected attribute

    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("Deposit amount must be positive")
        self.__balance += amount
        self._transaction_count += 1
        return self.__balance

    def withdraw(self, amount):
        if amount <= 0 or amount > self.__balance:
            raise ValueError("Invalid withdrawal amount")
        self.__balance -= amount
        self._transaction_count += 1
        return self.__balance

    def get_balance(self):
        return self.__balance

    def get_transaction_count(self):
        return self._transaction_count
```

### Using Encapsulation in Practice
```python
account = BankAccount("John Doe", 1000)
print(account.deposit(500))  # Output: 1500
print(account.withdraw(200)) # Output: 1300
print(account.get_balance()) # Output: 1300
```

### Accessing Private Attributes (Not Recommended)
```python
print(account._BankAccount__balance)  # Output: 1300 (Name mangling)
print(account._transaction_count)    # Output: 2 (Protected attribute)
```

---

## SECTION 4: POLYMORPHISM

### Analogy:
Polymorphism is like a TV remote control. The same "power" button works on different TV models and brands, but the actual implementation might be different for each. Similarly, different classes can implement the same method name, and each will respond in its own way.

### Example:
```python
class Animal:
    """Base class for all animals."""
    
    def __init__(self, name):
        """Initialize an Animal object."""
        self.name = name
    
    def speak(self):
        """The sound the animal makes (to be overridden by subclasses)."""
        raise NotImplementedError("Subclasses must implement this method")
    
    def introduce(self):
        """The animal introduces itself."""
        return f"I am {self.name} and I {self.speak()}"

class Dog(Animal):
    def speak(self):
        return "bark"

class Cat(Animal):
    def speak(self):
        return "meow"

class Duck(Animal):
    def speak(self):
        return "quack"

# Polymorphism in action
def animal_sound(animal):
    return animal.speak()

# Creating different animal objects
fido = Dog("Fido")
whiskers = Cat("Whiskers")
donald = Duck("Donald")

# Demonstration of polymorphism
print(animal_sound(fido))      # Output: bark
print(animal_sound(whiskers))  # Output: meow
print(animal_sound(donald))    # Output: quack

print(fido.introduce())       # Output: I am Fido and I bark
print(whiskers.introduce())   # Output: I am Whiskers and I meow
print(donald.introduce())     # Output: I am Donald and I quack
```

---
## SECTION 5: ABSTRACTION

### Analogy:
Abstraction is like driving a car. You don't need to understand how the engine works to drive it; you just need to know how to use the steering wheel, pedals, etc. Similarly, abstract classes define a common interface without implementing all the details.

### Example:
```python
from abc import ABC, abstractmethod

class Shape(ABC):
    """An abstract base class for geometric shapes."""
    
    @abstractmethod
    def area(self):
        pass
    
    @abstractmethod
    def perimeter(self):
        pass
    
    def describe(self):
        return f"This shape has an area of {self.area()} and a perimeter of {self.perimeter()}"

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius
    
    def area(self):
        return 3.14159 * self.radius ** 2
    
    def perimeter(self):
        return 2 * 3.14159 * self.radius

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height
    
    def area(self):
        return self.width * self.height
    
    def perimeter(self):
        return 2 * (self.width + self.height)

# Creating shape objects
circle = Circle(5)
rectangle = Rectangle(4, 6)

print(circle.area())        # Output: 78.53975
print(rectangle.area())     # Output: 24
print(circle.describe())    # Output: This shape has an area of 78.53975 and a perimeter of 31.4159
print(rectangle.describe()) # Output: This shape has an area of 24 and a perimeter of 20

# The following line would raise an error
# shape = Shape()  # TypeError: Can't instantiate abstract class Shape with abstract methods area, perimeter
```

---
## SECTION 6: PROPERTIES AND DESCRIPTORS

### Analogy:
Properties are like smart mailboxes that can perform checks when mail is deposited or retrieved. Similarly, properties let you add logic when attributes are accessed or modified.

### Example:
```python
class Temperature:
    """A class representing a temperature with validation."""
    
    def __init__(self, celsius=0):
        self.celsius = celsius
    
    @property
    def celsius(self):
        return self._celsius
    
    @celsius.setter
    def celsius(self, value):
        if value < -273.15:
            raise ValueError("Temperature cannot be below absolute zero")
        self._celsius = value
    
    @property
    def fahrenheit(self):
        return self.celsius * 9/5 + 32
    
    @fahrenheit.setter
    def fahrenheit(self, value):
        self.celsius = (value - 32) * 5/9

# Using properties
temp = Temperature(25)

print(temp.celsius)     # Output: 25
print(temp.fahrenheit)  # Output: 77.0

temp.celsius = 30
print(temp.fahrenheit)  # Output: 86.0

temp.fahrenheit = 68
print(temp.celsius)     # Output: 20.0

try:
    temp.celsius = -300  # This will raise a ValueError
except ValueError as e:
    print(f"Error: {e}")  # Output: Error: Temperature cannot be below absolute zero
```

## Class and Static Methods

In Python, `@classmethod` and `@staticmethod` are used to define methods that are not bound to an instance but rather to the class itself.

### Class Method (`@classmethod`)
- Takes `cls` as the first parameter.
- Can access and modify class state.

```python
class MyClass:
    class_variable = "Hello"
    
    @classmethod
    def class_method(cls):
        return f"Class method called, {cls.class_variable}"

print(MyClass.class_method())
```

### Static Method (`@staticmethod`)
- No access to `cls` or instance (`self`).
- Used for utility functions within a class.

```python
class MyClass:
    
    @staticmethod
    def static_method():
        return "Static method called"

print(MyClass.static_method())
```

## Magic Methods
Magic methods (also called dunder methods) allow us to define behaviors for operators and built-in functions.

### Common Magic Methods
- `__init__(self, ...)`: Constructor
- `__str__(self)`: String representation
- `__repr__(self)`: Official string representation
- `__len__(self)`: Returns length
- `__call__(self, ...)`: Makes an instance callable

```python
class Person:
    def __init__(self, name):
        self.name = name
    
    def __str__(self):
        return f"Person: {self.name}"
    
    def __call__(self):
        return f"Calling {self.name}!"

p = Person("Alice")
print(str(p))  # Calls __str__
print(p())     # Calls __call__
```

## Metaclasses
Metaclasses define the behavior of class creation. They control how classes are instantiated.

```python
class Meta(type):
    def __new__(cls, name, bases, dct):
        dct['custom_attr'] = "Added by metaclass"
        return super().__new__(cls, name, bases, dct)

class MyClass(metaclass=Meta):
    pass

print(MyClass.custom_attr)  # Outputs: Added by metaclass
```

## Design Patterns in Python
Design patterns provide reusable solutions to common problems in software design.

### Singleton Pattern
Ensures a class has only one instance.

```python
class Singleton:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

obj1 = Singleton()
obj2 = Singleton()
print(obj1 is obj2)  # True
```

### Factory Pattern
Encapsulates object creation.

```python
class Animal:
    def speak(self):
        pass

class Dog(Animal):
    def speak(self):
        return "Woof!"

class Cat(Animal):
    def speak(self):
        return "Meow!"


def animal_factory(animal_type):
    if animal_type == "dog":
        return Dog()
    elif animal_type == "cat":
        return Cat()
    raise ValueError("Unknown animal type")

pet = animal_factory("dog")
print(pet.speak())  # Outputs: Woof!
```

## Additional Topics

### Abstract Base Classes (ABC)
Abstract Base Classes (ABC) enforce method implementation in subclasses using the `abc` module.

```python
from abc import ABC, abstractmethod

class Animal(ABC):
    @abstractmethod
    def make_sound(self):
        pass

class Dog(Animal):
    def make_sound(self):
        return "Woof!"

d = Dog()
print(d.make_sound())
```

### Decorators
Decorators are used to modify the behavior of functions or methods dynamically.

```python
def my_decorator(func):
    def wrapper():
        print("Something before function execution")
        func()
        print("Something after function execution")
    return wrapper

@my_decorator
def say_hello():
    print("Hello!")

say_hello()
```

### Context Managers
Context managers help manage resources using the `with` statement.

```python
class FileOpener:
    def __init__(self, filename, mode):
        self.file = open(filename, mode)
    
    def __enter__(self):
        return self.file
    
    def __exit__(self, exc_type, exc_value, traceback):
        self.file.close()

with FileOpener("test.txt", "w") as file:
    file.write("Hello, World!")
```

### Threading and Multiprocessing
Python supports concurrency with threading and multiprocessing.

```python
import threading

def print_numbers():
    for i in range(5):
        print(i)

thread = threading.Thread(target=print_numbers)
thread.start()
thread.join()
```

```python
import multiprocessing

def worker():
    print("Worker process")

if __name__ == "__main__":
    process = multiprocessing.Process(target=worker)
    process.start()
    process.join()
```
