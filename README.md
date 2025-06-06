# CashRegister

A simple Rails 8 application implementing a cash register with flexible pricing rules:

* **Buy-One-Get-One-Free** on Green Tea (SKU: `GR1`)
* **Bulk discount** on Strawberries (SKU: `SR1`) when you purchase 3 or more
* **Volume discount** on Coffee (SKU: `CF1`): buy 3 or more and get each at 2/3 of the original price

Built with Ruby 3.4.2 and Rails 8.0.2.

---

## Table of Contents

* [Features](#features)
* [Recommended](#requirements)
* [Setup](#setup)
* [Database](#database)
* [Running the Server](#running-the-server)
* [Running Tests](#running-tests)
* [Pricing Rules](#pricing-rules)

---

## Features

* Manage products and a shopping cart
* Custom pricing rules:

  * Buy-One-Get-One-Free on Green Tea
  * Bulk price drop on Strawberries
  * Volume discount on Coffee
* Clear separation of concerns with service objects and pricing rules
* Test suite via RSpec and FactoryBot

---

## Recommended

* **Ruby** 3.4.2
* **Rails** 8.0.2
* **PostgreSQL** (for development & test)

---

## Setup

1. **Clone the repository**

   ```bash
   git clone https://github.com/jibril-tapiador/cash_register.git
   cd cash_register
   ```

2. **Install gems**

   ```bash
   bundle install
   ```

---

## Database

1. **Create and migrate**

   ```bash
   rails db:create
   rails db:migrate
   ```

2. **Seed the database**

   ```bash
   rails db:seed
   ```

This seeds three products:

* Green Tea (`GR1`)
* Strawberries (`SR1`)
* Coffee (`CF1`)

---

## Running the Server

```bash
bin/dev
```

Visit `http://localhost:3000` to browse products, add items to your cart, and see discounts applied in real time.

---

## Running Tests

```bash
bundle exec rspec
```

This will run all model, service, and request specs.

---

## Pricing Rules

* **BOGOF (Green Tea)**: Every second tea is free.
* **Bulk Price (Strawberries)**: Unit price drops to €4.50 when you buy 3 or more.
* **Volume Discount (Coffee)**: When buying 3+ coffees, unit price becomes 2/3 of €11.23.

All rules are implemented as service objects under `app/services/pricing_rules` and orchestrated by `CheckoutService`.
