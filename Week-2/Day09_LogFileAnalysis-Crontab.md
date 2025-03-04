# Day-9 SRE Training  

## Topic: Log File Analysis and Crontab  

### Log File Analysis  
We explored how to extract insights from a log file using various Linux commands:

- `[a-z]`  → Matches any lowercase letter (a to z).  
- `[A-Z]`  → Matches any uppercase letter (A to Z).  
- `[0-9]`  → Matches any digit (0 to 9).  
- `[a-zA-Z0-9.]`  → Matches any letter, digit, or period ( `.` ).  
- `[^...]`  → Matches any character NOT inside the brackets (negation).  
- `{2,}`  → At least 2 times Matches two or more occurrences of the preceding character or group.  
- `{1,3}`  → Between 1 and 3 times Matches at least 1 but at most 3 occurrences.  
- `+`  → One or more times (same as `{1,}`) Matches the preceding character or group at least once.  
- `.`  → Matches any single character (except newline). It is a wildcard that can match any character except a line break.  
- `*`  → Zero or more times Matches the preceding character or group any number of times (including zero).  

### Examples:

#### Extracting Email Addresses
```sh
grep -Eo '[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}' sample-logs.md
```
- `grep -E` enables extended regex.
- `-o` prints only matching email addresses.
- `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}` extracts emails from the log file.

#### Extracting Response Times
```sh
grep -E "completed in [0-9]{3,}ms" sample-logs.md
```
- `[0-9]{3,}`  matches numbers with 3 or more digits (e.g., `100ms`, `2500ms`).

```sh
grep -E "completed in [0-9]{4,}ms" sample-logs.md
```
- `[0-9]{4,}` matches numbers with 4 or more digits (e.g., `1000ms`, `25000ms`).

#### Extracting Usernames
```sh
grep "logged in successfully" sample-logs.md | awk -F "'" '{ print $2 }' | sort | uniq
```
- `awk -F "'"` sets the field separator to a single quote (`'`).
- Extracts unique usernames from log entries containing "logged in successfully".

#### Extracting Disk and Memory Usage
```sh
grep -E "Disk: [5-6][0-9]%" sample-logs.md | awk '{print $10 $11}'
```
- Filters lines where disk usage is between `50% and 69%`.
- Extracts and joins the `10th` and `11th` fields from those lines.

```sh
grep -E "Memory: [5-8][0-9]%" sample-logs.md | awk '{print $8 $9}'
```
- Filters lines where memory usage is between `50% and 89%`.
- Extracts and joins the `8th` and `9th` fields.

#### Filtering Specific Server Logs
```sh
awk '$4 == "[app-server-1]"' sample-logs.md
```
- Displays only the lines where the `4th` field is exactly `"[app-server-1]"`.

#### Counting Log Levels
```sh
awk '{ count[$3]++ } END { for (level in count) print level, count[level] }' sample-logs.md
```
- Counts occurrences of unique values in the `3rd` column.

#### Filtering Log Entries by Timestamp
```sh
awk '$0 >= "2024-02-01 10:00:00" && $0 <= "2024-02-01 12:00:00"' sample-logs.md
```
- Filters log entries within a specific timestamp range.

#### Counting Error Messages
```sh
grep -c "ERROR" sample-logs.md
```
- Counts the number of lines containing `"ERROR"`.

#### Extracting Log Data to CSV
```sh
awk 'BEGIN {OFS=","} {print $1, $2, $3}' sample-logs.md >> output.csv
```
- Extracts the first three fields (assumed to be Date, Level, and Server) and appends them to `output.csv`.

---

## Crontab  
`crontab` (short for "cron table") is a command in Linux used to schedule and manage recurring tasks (cron jobs). It allows users to automate commands or scripts at specific time intervals (e.g., every minute, daily, weekly).

### Common Crontab Commands

```sh
crontab -e  # Opens the user's crontab file for editing
crontab -l  # Lists the currently scheduled cron jobs
```

### Adding a Cron Job
```sh
(crontab -l 2>/dev/null; echo "* * * * * echo \"helloworld\"") | crontab -
```
- Runs every minute and echoes "helloworld".
- `crontab -l 2>/dev/null` lists existing cron jobs (ignoring errors if no jobs exist).
- `| crontab -` updates the crontab.

### Removing a Cron Job
```sh
crontab -l | grep -v "echo \"helloworld\"" | crontab -
```
- Removes the cron job that echoes "helloworld".

### Appending Logs Using Crontab
```sh
* * * * * echo "Hello, World!" >> /home/user/log.txt
```
- Runs every minute and appends `"Hello, World!"` to `log.txt`.

### Scheduling a Script to Run at 6 AM
```sh
echo "0 6 * * * /path/to/script.sh" | crontab -
```
- Runs `/path/to/script.sh` every day at `6 AM`.

### Removing All Cron Jobs
```sh
crontab -r
```
- Deletes all scheduled cron jobs for the current user.

