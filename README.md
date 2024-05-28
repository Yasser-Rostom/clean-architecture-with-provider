# clean-architecture-with-provider
A small listing app using the Provider pattern with TDD and clean architecture. 
CI/CD configured using Github actions to ensure the update passes all tests.

## Some of the packages used:
1) Mockito for testing
2) Sharedpreferences for local caching
3) Either for handling failure
4) Provider for state management.

## Key Features:
1) Fetch and Display Photos: Retrieve photos from a remote API and display them in a list.
2) Error Handling: Graceful handling of server and cache errors.
3) Caching: Cache photos locally to ensure offline functionality.
4) State Management: Efficient state management using the Provider package.
5) Clean Architecture: Separation of concerns through layered architecture.
