# React

## What is React?

React is a JavaScript library for building user interfaces (UIs). It allows developers to create reusable UI components and manage the state of their applications efficiently.

## Why React?

* **Component-Based Architecture:** React encourages breaking down UIs into smaller, reusable components, making development more organized and maintainable.
* **Declarative Syntax:** You describe *what* you want the UI to look like, and React handles *how* to update the DOM.
* **Performance:** React's Virtual DOM optimizes UI updates, leading to better performance.
* **Large Community and Ecosystem:** React has a vast community and a rich ecosystem of libraries and tools.

## DOM (Document Object Model)

The DOM is a programming interface for web documents. It represents the page as a tree-like structure of objects, allowing JavaScript to access and manipulate the content, structure, and style of a webpage.

## Virtual DOM

The Virtual DOM is a lightweight, in-memory representation of the actual DOM. React uses it to optimize UI updates.

## How Virtual DOM Works (Simple Terms)

1.  **Imagine two snapshots:** Think of the Virtual DOM as taking a "snapshot" of the UI before and after a change.
2.  **Find the differences:** React compares these snapshots to find the differences.
3.  **Update only what's changed:** Instead of directly updating the entire DOM, React only updates the specific parts that have changed. This is much faster.

## How to Install React Dependencies

1.  **Node.js and npm (or yarn):** Make sure you have Node.js and npm (or yarn) installed.
2.  **Create React App:**
    ```bash
    npx create-react-app my-app
    cd my-app
    ```
    * `npx create-react-app my-app` creates a new React project named "my-app".
    * `cd my-app` navigates into the project directory.
3.  **Install Dependencies:**
    * `npm install` (or `yarn install`) installs the required dependencies listed in `package.json`.

## Entry Point and App Start

* **`public/index.html`:** This is the main HTML file that the browser loads.
* **`src/index.js`:** This is the JavaScript entry point.
* **`ReactDOM.render()`:** This function renders the root component (`App.js`) into the `root` element in `index.html`.
* **App.js:** The root component of your application, which is the starting point for all other components.

Essentially, the browser loads `index.html`, which runs `index.js`, which renders `App.js`, and from there, your React application begins its execution.

## How to Run the React App

1.  **Navigate to the project directory:**
    ```bash
    cd my-app
    ```
2.  **Start the development server:**
    ```bash
    npm start
    ```
    * This will start a local development server, and your React app will open in your default browser.

## Counter.jsx

```jsx
import React, { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0); // Remember the number

  return (
    <div>
      <p>Count: {count}</p> // Show the number
      <button onClick={() => setCount(count + 1)}>Increment</button> // Add 1
      <button onClick={() => setCount(count - 1)}>Decrement</button> // Subtract 1
      <button onClick={() => setCount(0)}>Reset</button> // Go to 0
    </div>
  );
}

export default Counter;
```

## How it works:

1.  **"useState" remembers the number:**
    * **useState explanation:** `useState` is a React Hook that lets you add React state to function components. It declares a "state variable" that you can preserve between function calls. In our case, `const [count, setCount] = useState(0);` creates a state variable called `count` and initializes it to 0. It also gives you a function, `setCount`, to update that variable.
    * It's like a special box that stores the count.
    * It starts with 0.
2.  **Buttons change the number:**
    * When you click a button, it tells "useState" to change the number.
    * "Increment" adds 1.
    * "Decrement" subtracts 1.
    * "Reset" sets it to 0.
3.  **React updates the screen:**
    * When the number changes, React makes the screen show the new number.
  
<div style="display: flex;">
  <img src="../images/day-22/screenshot2.jpg" alt="A cat image" style="width: 47%; margin-right: 5px;">
  <img src="../images/day-22/screenshot1.jpg" alt="A dog image" style="width: 47%; margin-left: 5px;">
</div>

## React Theme Toggle

```jsx
import React, { useState } from 'react';

function ThemeToggle() {
  const [theme, setTheme] = useState('light'); // Remember the theme

  const toggleTheme = () => {
    setTheme(theme === 'light' ? 'dark' : 'light'); // Change the theme
  };

  return (
    <button onClick={toggleTheme}>
      {theme === 'light' ? 'Dark Mode' : 'Light Mode'} // Change button text
      <style jsx>{`
        body {
          background-color: ${theme === 'light' ? 'white' : '#333333'}; // Change background color
          color: ${theme === 'light' ? 'black' : 'white'}; // Change text color
        }
      `}</style>
    </button>
  );
}

export default ThemeToggle;
```
## How it works:

This component toggles a light/dark theme with a button. 
`useState` stores the current theme ('light' or 'dark'). 
Clicking the button calls `toggleTheme`, which flips the theme state. 
Styled-jsx dynamically applies CSS to the `body` tag, changing background and text colors based on the current theme state. 
The button text also changes to reflect the next theme.

<div style="display: flex;">
  <img src="../images/day-22/screenshot3.jpg" alt="A cat image" style="width: 47%; margin-right: 5px;">
  <img src="../images/day-22/screenshot4.jpg" alt="A dog image" style="width: 47%; margin-left: 5px;">
</div>

## React Todo Component

```jsx
import React, { useState } from 'react';

function Todo() {
  const [todos, setTodos] = useState([]);
  const [input, setInput] = useState('');

  const addTodo = () => {
    if (input.trim() !== '') {
      setTodos([...todos, input]);
      setInput('');
    }
  };

  const removeTodo = (index) => {
    setTodos(todos.filter((_, i) => i !== index));
  };

  return (
    <div>
      <h1>Todo List</h1>
      <input
        type="text"
        value={input}
        onChange={(e) => setInput(e.target.value)}
        placeholder="Add a todo"
      />
      <button onClick={addTodo}>Add</button>
      <ul>
        {todos.map((todo, index) => (
          <li key={index}>{todo}</li>
        ))}
      </ul>
    </div>
  );
}

export default Todo;
```
## How it works:

This component builds a basic todo list. 
`useState` manages the list of todos and the input field's text. 
The `addTodo` function adds new tasks to the list if the input is not empty. 
The `removeTodo` function removes tasks. The UI displays an input for new tasks, an "Add" button, and a list of current tasks. 
Each task is shown as a list item.

## React User Input Component

```jsx
import React, { useState } from 'react';

function UserInput() {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [address, setAddress] = useState('');
  const [users, setUsers] = useState([]); // Array to store user data
  const [newUserField, setNewUserField] = useState(''); // New user input field

  const handleSubmit = (e) => {
    e.preventDefault();
    setUsers([...users, { name, email, address, newUserField }]); // Add new user to the array
    setName('');
    setEmail('');
    setAddress('');
    setNewUserField(''); // Clear input fields after submission
  };

  return (
    <div>
        <h1>User Input</h1>
      <form onSubmit={handleSubmit}>
        <label>
          Name:
          <input
            type="text"
            value={name}
            onChange={(e) => setName(e.target.value)}
          />
        </label>
        <br />
        <label>
          Email:
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
          />
        </label>
        <br />
        <label>
          Address:
          <input
            type="text"
            value={address}
            onChange={(e) => setAddress(e.target.value)}
          />
        </label>
        <br />
        <br />
        <br />
        <button type="submit">Submit</button>
      </form>

      <table style={{ margin: '0 auto' }}>
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Address</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user, index) => (
            <tr key={index}>
              <td>{user.name}</td>
              <td>{user.email}</td>
              <td>{user.address}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default UserInput;
```

## How it works:
This component creates a form to collect user information (name, email, address). 
`useState` manages input values and an array of submitted users. 
On form submit, `handleSubmit` adds the user data to the `users` array and clears the input fields. 
The component then renders a table displaying the submitted user data. The table maps through the `users` array, creating a table row for each user.
