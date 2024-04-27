import { useState } from 'react';

const LoginPage = () => {
  const apiUrl = 'http://localhost:3001';
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [users, setUsers] = useState([]);

  // useEffect(() => {
  //   getUsers();
  // }, []);

  const getUsers = async () => {
    await fetch(`${apiUrl}/read/user`)
      .then(async (res) => await res.json())
      .then((users) => {
        if (users === undefined) {
          setUsers([{ username: 'undefined', password: 'undefined' }]);
        } else {
          setUsers(users);
        }
      });
  };
  const createUser = async () => {
    if (username === '' || password === '') {
      console.error('Must have non-empty username and password');
      return;
    }
    fetch(`${apiUrl}/create/user`, {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ username: username, password: password }),
    })
      .then(async (response) => await response.json())
      .then((response) => console.log(JSON.stringify(response)));

    setUsers((prev) => [...prev, { username: username, password: password }]);
    setUsername('');
    setPassword('');
  };

  return (
    <>
      <label>Username: </label>
      <input
        type="text"
        name="username"
        value={username}
        onChange={(e) => setUsername(e.target.value)}
        required
      />
      <br />

      <label>Password: </label>
      <input
        type="password"
        name="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        required
      />
      <br />

      <button onClick={createUser}>Submit</button>
      <br />
      <br />

      <table border="1">
        <thead>
          <tr>
            <th>IDe</th>
            <th>Name</th>
            <th>Password</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => {
            return (
              <tr key={user.user_id}>
                <td>{user.user_id}</td>
                <td>{user.username}</td>
                <td>{user.password}</td>
              </tr>
            );
          })}
        </tbody>
      </table>
    </>
  );
};

export default LoginPage;
