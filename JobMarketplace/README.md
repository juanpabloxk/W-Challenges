# High-Performance Job Marketplace API

This is a Ruby on Rails API for a job marketplace, built with focus on performance and scalability.

## Performance

The API is designed for high performance and low latency responses (ms range):

- **N+1 Query Prevention**: We use `includes` to eager load associations and prevent N+1 queries.
- **Fast Pagination**: We use the [Pagy](https://github.com/ddnexus/pagy) gem for fast and efficient pagination.
- **Response Caching**: API responses for listings are cached using Rails' cache store to ensure millisecond-level response times for repeated requests.

## Endpoints

### Opportunities

| Endpoint                      | Description                      |
|-------------------------------|----------------------------------|
| `GET /api/v1/opportunities`   | Returns a list of opportunities. |
| `POST /api/v1/opportunities` | Creates a new opportunity. |
| `POST /api/v1/opportunities/:id/apply` | Applies for an opportunity. |

## Getting Started

### Prerequisites

- Ruby (as defined in `.ruby-version` and `Gemfile`)
- PostgreSQL (16 or higher)
- Redis (6.2 or higher)

### Running the app

1.  Install dependencies:
    ```bash
    bundle install
    ```

2.  Set up the database:
    ```bash
    rails db:setup
    ```

3.  Run the web server:
    ```bash
    bundle exec rails s
    ```

4.  Run the Sidekiq server for background jobs:
    ```bash
    bundle exec sidekiq
    ```

## Database Seeding

You can seed the database with sample data by running:

```bash
rails db:seed
```

The seeding process is idempotent, meaning you can run it multiple times without creating duplicate data. It uses a fixed seed, so the generated data will be the same every time.
