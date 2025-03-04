# Day - 8 SRE Training

## Topic - Shell Scripting Arrays  

### Declaring Array Variables
```sh
a[0]= "ab"  
a[1]= "cd"
a[2]=23
```

### Displaying Array Elements
```sh
echo $a  # Displays a[0]
echo " $a "
echo " $a [2]"
echo " ${a[1]} "  # Displays a[1]
echo " ${a[2]} "
echo " ${a} "
echo " ${a[@]} "  # Displays entire array
echo " ${a[*]} "  # Displays entire array
```

### Print Array using For Loop
```sh
echo "Print array using for loop: "
for i in " ${a[@]} "
do
echo " $i "
done
```

### Arithmetic Operations in Shell Scripting
```sh
x=15
y=5
echo "sum: $((x+y))"
echo "diff: $((x-y))"
echo "multiplication: $((x*y))"
echo "div: $((x/y))"
```

### Comparison Operators
| Operator | Description |
|----------|-------------|
| -ge | Greater than or equal to |
| -gt | Greater than |
| -le | Less than or equal to |
| -lt | Less than |
| -eq | Equal to |
| -ne | Not equal to |

### Logical Operators
| Operator | Description |
|----------|-------------|
| -o or `||` | Logical OR |
| -a or `&&` | Logical AND |

### String Comparisons
| Operator | Description |
|----------|-------------|
| `=` | String comparison for equality |
| `-z` | Checks if a string is empty |

### Banking Example
```sh
balance=1400
min_balance=500
withdrawal=600
daily_limit=1000
account_type="savings"
description=""

if [ $balance -ge $min_balance ]; then
echo "Minimum balance is maintained"
fi

if [ $min_balance -eq 500 ]; then
echo "Minimum balance is maintained to 500"
fi

if [ $min_balance -ne 500 ]; then
echo "Minimum balance is not 500"
fi

if [ $balance -gt $withdrawal ]; then
balance=$((balance - withdrawal))
echo "Withdrawal successful, balance = $balance"
fi

if [ $withdrawal -le $balance -a $withdrawal -le $daily_limit ]; then
echo "Transaction approved"
else
echo "Transaction not approved"
fi

if [ "$account_type" = "savings" ]; then
echo "This is a savings account"
fi

if [ -z "$description" ]; then
echo "Description is not provided"
fi
```

### File Operations
| Operator | Description |
|----------|-------------|
| -s | Checks if file exists and is not empty |
| -e | Checks if file exists |
| -r | Checks if file has read permission |
| -w | Checks if file has write permission |
| -x | Checks if file has execute permission |

```sh
file1="new.txt"
if [ -s "$file1" ]; then
echo "new exists and is not empty"
fi

if [ -e "$file1" ]; then
echo "new exists"
fi

if [ -r "$file1" ]; then
echo "$file1 has read permission"
fi

if [ -w "$file1" ]; then
echo "$file1 has write permission"
fi

if [ -x "$file1" ]; then
echo "$file1 has execute permission"
fi
```

### User Input
```sh
read name  # Reads user input and stores in 'name'
echo "$name"

read -p "Enter account number and password: " accno password
echo $accno
echo $password

read -s -p "Enter password" p  # Silent input
```

### Case Statement Example
```sh
read -p "Enter selection [1-3]: " selection
case $selection in
1) accounttype="checking"; echo "You have selected checking";;
2) accounttype="saving"; echo "You have selected saving";;
3) accounttype="current"; echo "You have selected current";;
*) accounttype="random"; echo "Random selection";;
esac
```

### Grep Commands
| Command | Description |
|----------|-------------|
| `grep "pattern" filename` | Searches for an exact pattern in a file |
| `grep "a.b" filename` | Matches a three-character sequence where 'a' is the first character, 'b' is the last, and any character is in between |
| `grep "[0-9]" filename` | Matches any single digit |
| `grep "[a-zA-Z]" filename` | Matches any single uppercase or lowercase letter |

### Simple Calculator
```sh
read -p "Enter two values val1 and val2: " val1 val2
read -p "Enter operator [+ - * /]: " op
case $op in
+) echo $((val1 + val2));;
-) echo $((val1 - val2));;
\*) echo $((val1 * val2));;
/) echo $((val1 / val2));;
*) echo "Enter a valid operand: + - * /";;
esac
```

