import React , { useState } from 'react';
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
                    <li key={index}>{todo}
                    </li>
                ))}
            </ul>
        </div>
    )
    
}
export default Todo;