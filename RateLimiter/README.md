# Sliding Window Rate Limiter

## Description

This is a simple rate limiter implementation that uses a sliding window to track the number of requests per user.

## Design decisions

- A hash is used to store the requests for each user, since it allows for O(1) time complexity for both insertion and lookup.

## Performance

- `Hash.reject!` time complexity is O(n), where n is the number of elements in the hash.
- The time complexity of the `allow_request?` method is O(1), since it only involves a hash lookup and insertion.
