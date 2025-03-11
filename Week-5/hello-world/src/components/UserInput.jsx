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
        {/* <label>
          New Field:
          <input
            type="text"
            value={newUserField}
            onChange={(e) => setNewUserField(e.target.value)}
          />
        </label> */}
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