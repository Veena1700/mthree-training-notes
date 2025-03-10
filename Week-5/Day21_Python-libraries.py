import numpy as np

#Create an array
arr = np.array([1, 2, 3, 4, 5])
arr_2d = np.array([[1, 2, 3], [4, 5, 6]])
print(arr)
print(arr_2d)

#Create an array with random numbers
arr_random = np.random.rand(3, 4)

zeros_array = np.zeros((3, 4))
ones_array = np.ones((3, 4))
full_array = np.full((3, 4), 10)

print(arr_random)
print(zeros_array)
print(ones_array)
print(full_array)

#Create an array with a range of numbers
arr_range = np.arange(10, 20, 0.5)
print(arr_range)

#Create an array with a range of numbers with a step
arr_range_step = np.arange(10, 20, 0.5)
print(arr_range_step)

#Matrix addition
matrix_1 = np.array([[1, 2, 3], [4, 5, 6]])
matrix_2 = np.array([[1, 2, 3], [4, 5, 6]])
matrix_addition = matrix_1 + matrix_2
print(matrix_addition)

#Matrix subtraction
matrix_subtraction = matrix_1 - matrix_2
print(matrix_subtraction)

#Matrix multiplication
matrix_multiplication = matrix_1 * matrix_2
print(matrix_multiplication)

#Matrix division
matrix_division = matrix_1 / matrix_2
print(matrix_division)

#Matrix power
matrix_power = matrix_1 ** matrix_2
print(matrix_power)

#Matrix transpose
matrix_transpose = matrix_1.T
print(matrix_transpose)

# Matrix dot product
matrix_dot_product = np.dot(matrix_1, matrix_2.T)
print(matrix_dot_product)

#Numpy mean median mode
arr_mean = np.mean(arr)
arr_median = np.median(arr)

print(arr_mean)
print(arr_median)

#Numpy standard deviation and variance
arr_std = np.std(arr)
arr_var = np.var(arr)
print(arr_std)
print(arr_var)

import pandas as pd

series = pd.Series([1, 2, 3, 4, 5])
print(series)

series_2 = pd.Series([1, 2, 3, 4, 5], index=['a', 'b', 'c', 'd', 'e'])
print(series_2)

data = {
    'Name': ['John', 'Jane', 'Jim', 'Jill'],
    'Age': [20, 21, 22, 23],
    'City': ['New York', 'Los Angeles', 'Chicago', 'Houston']
}

df = pd.DataFrame(data)
print(df)

#Create a dataframe from a csv file
df_csv = pd.read_csv('src/basic_module/numerical/data.csv')
print(df_csv)

df_csv = pd.concat([df_csv, df_csv])
print(df_csv)
next_idx = len(df_csv)
print(next_idx)
#Create a dataframe from a sql table
df_csv.loc[next_idx] = ['Ashfdkjshn', 20, 'New York', 75000, '2024-02-15']
print(df_csv)
df_csv.to_csv('df_csv.csv', index=False)

from sqlalchemy import create_engine, text, MetaData, Table, Column, Integer, String, ForeignKey, insert, select
engine = create_engine('sqlite:///data',echo=True)

# engine = create_engine('sqlite:///my_database.db')  # Create database
# current_directory = os.getcwd()
# database_path = os.path.join(current_directory, 'my_database.db')
# print(f"Database path: {database_path}")

metadata = MetaData()

users = Table('users', metadata,
    Column('id', Integer, primary_key=True),
    Column('name', String),
    Column('age', Integer),
    Column('city', String),
)
posts = Table('posts', metadata,
    Column('id', Integer, primary_key=True),
    Column('title', String),
    Column('content', String),
    Column('user_id', Integer, ForeignKey('users.id')),
)

metadata.create_all(engine)

with engine.connect() as con:
    insert_stmt = insert(users).values(name='John', age=20, city='New York')
    result = con.execute(insert_stmt)
    print(result.rowcount)

    insert_stmt = insert(posts).values(title='Post 1', content='Content 1', user_id=1)
    result = con.execute(insert_stmt)
    print(result.rowcount)

    con.commit()

    select_stmt = select(users)
    result = con.execute(select_stmt)
    for row in result:
        print(row)

    select_stmt = select(posts)
    result = con.execute(select_stmt)
    for row in result:
        print(row)
