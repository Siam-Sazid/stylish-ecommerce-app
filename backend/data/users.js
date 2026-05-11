const bcrypt = require('bcryptjs');

// Pre-hashed password: "password123"
const passwordHash = bcrypt.hashSync('password123', 10);

const users = [
  {
    id: 'u1',
    name: 'John Doe',
    email: 'john@example.com',
    password: passwordHash,
    avatarUrl: 'https://picsum.photos/seed/johndoe/200/200',
  },
];

module.exports = users;
