# 🏄‍♂️ Windsurfing E-Commerce Platform

A modern, responsive e-commerce platform built with Ruby on Rails and Tailwind CSS, specialized for windsurfing equipment and accessories.

![alt text](gallery/signup.png)

![alt text](gallery/signin.png)

![alt text](gallery/product_index.png)

![alt text](gallery/product_show.png)

![alt text](gallery/cart_index.png)

![alt text](gallery/cart_empty.png)

## ✨ Features

- 🛍️ **Product Management**
  - Full CRUD operations for products
  - Image upload support via Active Storage
  - Stock tracking
  - Detailed product views with image gallery

- 🛒 **Shopping Cart**
  - Real-time cart updates
  - Quantity management
  - Stock validation
  - Dynamic price calculations

- 👤 **User Authentication**
  - Secure user registration and login
  - Role-based authorization
  - Protected admin routes

- 🎨 **Modern UI/UX**
  - Responsive design
  - Orange-themed styling
  - Interactive components
  - Tailwind CSS utilities

## 🚀 Tech Stack

- **Framework**: Ruby on Rails 8.0
- **Database**: SQLite
- **Frontend**: 
  - Tailwind CSS
  - Stimulus.js
  - Turbo
- **Authentication**: Devise
- **File Storage**: Active Storage
- **JavaScript**: ES6+

## 📦 Installation

1. Clone the repository
```bash
git clone [repository-url]
cd windsurfing
```

2. Install dependencies
```bash
bundle install
yarn install
```

3. Setup database
```bash
rails db:create
rails db:migrate
```

4. Start the server
```bash
bin/dev
```

5. Visit `http://localhost:3000`

## 💻 Development

- Run tests: `rails test`
- Run linter: `rubocop`
- Generate ERD: `rails erd`

## 🔒 Environment Variables

Create a `.env` file in the root directory and add:

```
DATABASE_URL=your_database_url
RAILS_MASTER_KEY=your_master_key
```

## 📝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## 🙏 Acknowledgments

- Ruby on Rails team
- Tailwind CSS team
- All contributors and supporters