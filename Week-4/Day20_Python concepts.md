# Python Concepts

## Class Definitions

### `Animal` Class (Base Class)
```python
class Animal:
    def __init__(self, name):
        self.name = name  # Constructor initializing the name attribute
    
    def __str__(self):
        return f"Animal {self.name}"  # String representation method
    
    def speak(self):
        return f"Animal {self.name} is speaking"  # Base method for polymorphism
```
- The `Animal` class is a base class that initializes an attribute `name`.
- The `__str__` method returns a string representation of the object.
- The `speak` method provides a generic way for an animal to make a sound.

### `Dog` Class (Inheritance, Method Overriding, and Overloading)
```python
class Dog(Animal):
    def speak(self, age=0):
        return f"Dog {self.name} is barking and {age} years old"  # Overloaded method
    
    def __str__(self):
        return f"Dog {self.name}"  # Overridden __str__ method
```
- The `Dog` class inherits from `Animal`.
- Method overriding: The `speak` method is redefined to provide a specific behavior.
- Method overloading: The `speak` method takes an optional parameter `age`.

### `Cat` and `Bird` Classes (Method Overriding)
```python
class Cat(Animal):
    def speak(self):
        print(f"Cat {self.name} is meowing")  # Overridden method

class Bird(Animal):
    def speak(self):
        print(f"Bird {self.name} is chirping")  # Overridden method
```
- Both `Cat` and `Bird` override the `speak` method to provide their own behaviors.

## Main Function
```python
def main():
    dog1 = Animal("Buddy2")
    print(dog1.speak())  # Calls base class speak method
    
    dog = Dog("Buddy")
    print(dog.speak())  # Calls overridden method with default age
    print(dog.speak(10))  # Calls overloaded method with age
    print(dog)  # Calls overridden __str__ method
    
    dog1 = Dog("Buddy1")
    print(dog1.speak(10))  # Calls overloaded method

if __name__ == "__main__":
    main()
```
- Creates instances of `Animal` and `Dog` classes.
- Demonstrates method overriding and overloading.
- Prints the string representation of `Dog` objects.

- **Inheritance**: `Dog`, `Cat`, and `Bird` inherit from `Animal`.
- **Method Overriding**: `speak` is redefined in `Dog`, `Cat`, and `Bird`.
- **Method Overloading**: `speak` in `Dog` accepts an optional parameter.
- **Encapsulation**: `name` attribute is encapsulated within the class.
- **Polymorphism**: Different implementations of `speak` across classes.


# What is a Destructor?
A **destructor** is a special method, `__del__`, that is automatically called when an object is about to be destroyed. It is useful for releasing resources such as closing file handles, database connections, or freeing up memory.

## Code Explanation

### `Resource` Class (Demonstrating Constructor and Destructor)
```python
class Resource:
    def __init__(self, name):
        self.name = name
        print(f"Resource {self.name} is created")
        
    def __del__(self):
        print(f"Resource {self.name} is being destroyed")
        
    def use_resource(self):
        print(f"Using resource {self.name}")
```
- `__init__`: The constructor initializes the `name` attribute and prints a message when a resource is created.
- `__del__`: The destructor prints a message when an object is destroyed.
- `use_resource`: A method to simulate using the resource.

### `demonstrate_destructor` Function
```python
def demonstrate_destructor():
    # Create a resource
    print("Creating first resource")
    r1 = Resource("Database Connection")
    r1.use_resource()
    
    # Create another resource
    print("\nCreating second resource") 
    r2 = Resource("File Handle")
    r2.use_resource()
    
    # r1 will be destroyed when it goes out of scope
    print("\nLetting r1 go out of scope")
    del r1
    
    print("\nProgram continuing...")
    # r2 will be automatically destroyed when the function ends
```
- Creates two `Resource` objects (`r1` and `r2`).
- Calls `use_resource` to simulate usage.
- Explicitly deletes `r1` to trigger its destructor.
- When `demonstrate_destructor` ends, `r2` is automatically destroyed.

### Main Program Execution
```python
if __name__ == "__main__":
    print("Starting program")
    demonstrate_destructor()
    print("\nProgram finished")
    # Any remaining resources will be cleaned up when the program ends
```
- Runs `demonstrate_destructor` to illustrate object creation and deletion.
- At the end of the program, any remaining objects are cleaned up.

- **Destructors (`__del__`)** are useful for releasing resources automatically.
- **Objects are destroyed** when they go out of scope or explicitly deleted.
- **Python's garbage collector** handles memory cleanup but calling `del` ensures immediate destruction.

# Understanding Shallow Copy and Deep Copy in Python

## What is Copying in Python?
Copying an object in Python can be done in two ways: **shallow copy** and **deep copy**. The difference lies in how nested objects (such as lists inside lists) are copied.

## Shallow Copy (`copy.copy`)
A **shallow copy** creates a new object but does not create copies of nested objects. Instead, it references the same nested objects as the original.

### Example:
```python
import copy

# Original list with nested objects
original_list = [[1, 2, 3], [4, 5, 6]]
print("Original list:", original_list)

# Creating a shallow copy
shallow_copy = copy.copy(original_list)
print("\nShallow copy:", shallow_copy)

# Modifying a nested object in the shallow copy
shallow_copy[0][0] = 'X'
print("Original list after modifying shallow copy:", original_list)  # Original is modified
print("Shallow copy after modification:", shallow_copy)
```

### Explanation:
- The outer list is copied, but the inner lists are still referenced.
- Modifying `shallow_copy[0][0]` changes `original_list[0][0]` as well.

## Deep Copy (`copy.deepcopy`)
A **deep copy** creates a completely independent copy, including nested objects.

### Example:
```python
# Creating a deep copy
deep_copy = copy.deepcopy(original_list)
print("\nDeep copy:", deep_copy)

# Modifying nested object in deep copy
deep_copy[0][0] = 'Y'
print("Original list after modifying deep copy:", original_list)  # Original remains unchanged
print("Deep copy after modification:", deep_copy)
```

### Explanation:
- The entire object, including nested objects, is copied.
- Modifying `deep_copy[0][0]` does not affect `original_list`.

## Checking Object IDs for Better Understanding
You can check object IDs to see if copies reference the same nested objects.

### Example:
```python
# Checking IDs for shallow copy
print("\n--- ID Comparisons for Shallow Copy ---")
print("ID of original list:", id(original_list))
print("ID of shallow copy:", id(shallow_copy))
print("ID of nested object in original:", id(original_list[0]))
print("ID of nested object in shallow copy:", id(shallow_copy[0]))  # Same as original

# Checking IDs for deep copy
print("\n--- ID Comparisons for Deep Copy ---")
print("ID of original list:", id(original_list))
print("ID of deep copy:", id(deep_copy))
print("ID of nested object in original:", id(original_list[0]))
print("ID of nested object in deep copy:", id(deep_copy[0]))  # Different from original
```

- **Shallow Copy (`copy.copy`)**: Copies the top-level structure but references the same nested objects.
- **Deep Copy (`copy.deepcopy`)**: Creates an entirely new object, including copies of all nested objects.
- **Checking Object IDs** helps visualize memory management and references.

# Exception Handling in Python

Exception handling is a mechanism in Python to manage runtime errors and prevent program crashes. The `try-except` block is used to catch and handle exceptions gracefully.

## 1. Basic Try-Except Block
```python
try:
    x = 10 / 0  # This will raise a ZeroDivisionError
except ZeroDivisionError as e:
    print(f"Error: Division by zero! {e}")
```
**Explanation:**
- The code inside `try` attempts to divide by zero, which is not allowed.
- The `except` block catches `ZeroDivisionError` and prints an error message.

## 2. Multiple Except Blocks
```python
try:
    numbers = [1, 2, 3]
    print(numbers[5])  # This will raise an IndexError
except IndexError:
    print("Error: Index out of range!")
except Exception as e:
    print(f"Some other error occurred: {e}")
```
**Explanation:**
- The code tries to access an invalid index in a list.
- The `except IndexError` block catches and handles `IndexError`.
- The generic `except Exception as e` block catches any other errors.

## 3. Try-Except-Else-Finally
```python
try:
    file = open("nonexistent.txt", "r")
except FileNotFoundError:
    print("Error: File not found!")
else:
    print("File operations successful!")  # Runs if no exception occurs
finally:
    print("This will always execute!")  # Always runs
```
**Explanation:**
- `except` handles `FileNotFoundError` when the file does not exist.
- `else` executes if no exception occurs.
- `finally` runs regardless of whether an exception occurs or not.

## 4. Raising Custom Exceptions
```python
class CustomError(Exception):
    pass

try:
    age = -5
    if age < 0:
        raise CustomError("Age cannot be negative!")
except CustomError as e:
    print(f"Caught custom error: {e}")
```
**Explanation:**
- A custom exception class `CustomError` is created.
- The `raise` keyword triggers `CustomError` if `age` is negative.
- The `except` block catches and handles the custom exception.

- **`try`**: Defines the block of code to test for errors.
- **`except`**: Catches and handles exceptions.
- **`else`**: Executes if no exception occurs.
- **`finally`**: Always executes, regardless of exceptions.
- **`raise`**: Used to trigger exceptions manually.

# File Operations in Python

## 1. Create a File
Creates a new file and writes content into it.
```python
with open("test.txt", "w") as file:
    file.write("Hello, World!")
```

## 2. Write to a File
Overwrites the file content with new data.
```python
with open("test.txt", "w") as file:
    file.write("New Content!")
```

## 3. Read from a File
Reads and prints file content.
```python
with open("test.txt", "r") as file:
    print(file.read())
```

## 4. Append to a File
Adds new content to an existing file.
```python
with open("test.txt", "a") as file:
    file.write("Appending Data!")
```

## 5. Delete a File
Deletes a file if it exists.
```python
import os
if os.path.exists("test.txt"):
    os.remove("test.txt")
```

## 6. Check if a File Exists
Checks for file existence.
```python
import os
if os.path.exists("test.txt"):
    print("File exists")
else:
    print("File does not exist")
```

## 7. Get the Current Working Directory
Prints the current directory.
```python
import os
print(os.getcwd())
```

## 8. List All Files in a Directory
Displays all files in the current directory.
```python
import os
print(os.listdir())
```

## 9. Get the Size of a File
Fetches file size in bytes.
```python
import os
print(os.path.getsize("test.txt"))
```

## 10. Get the Last Modified Time of a File
Gets the last modified timestamp.
```python
import os
print(os.path.getmtime("test.txt"))
```

## 11. Get the File Type
Extracts the file extension.
```python
import os
print(os.path.splitext("test.txt"))
```

## 12. Get the File Name
Retrieves only the file name.
```python
import os
print(os.path.basename("test.txt"))
```

## 13. Get the File Extension
Prints only the extension of the file.
```python
import os
print(os.path.splitext("test.txt")[1])
```

## 14. Get the File Path
Displays the absolute path of the file.
```python
import os
print(os.path.abspath("test.txt"))
```

## 15. Get the File Directory
Retrieves the directory path of the file.
```python
import os
print(os.path.dirname("test.txt"))
```

### Running the Script
To execute all operations, use:
```python
if __name__ == "__main__":
    create_file()
    write_to_file()
    read_from_file()
    append_to_file()
    delete_file()
    create_file()
    check_if_file_exists()
    get_current_working_directory()
    list_files_in_directory()
    get_size_of_file()
    get_last_modified_time_of_file()
    get_file_type()
    get_file_name()
    get_file_extension()
    get_file_path()
    get_file_directory()
```
