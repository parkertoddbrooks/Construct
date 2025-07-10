# C# Language Patterns

## Overview
This pattern enforces modern C# best practices and coding standards.

## Rules

### Naming Conventions
```csharp
❌ NEVER: camelCase for public properties
✅ ALWAYS: PascalCase for public properties

❌ NEVER: Hungarian notation (strName, intCount)
✅ ALWAYS: Descriptive names without type prefixes

❌ NEVER: Abbreviations in names
✅ ALWAYS: Full descriptive names (GetUserAccount not GetUsrAcct)
```

### Async/Await Patterns
```csharp
❌ NEVER: Blocking on async code with .Result or .Wait()
✅ ALWAYS: Use async/await throughout the call chain

❌ NEVER: async void (except event handlers)
✅ ALWAYS: async Task or async Task<T>

❌ NEVER: Missing ConfigureAwait in libraries
✅ ALWAYS: ConfigureAwait(false) in library code
```

### Null Safety
```csharp
❌ NEVER: Ignoring nullable reference types
✅ ALWAYS: Enable nullable reference types

❌ NEVER: Throwing NullReferenceException
✅ ALWAYS: Use null checks and null-conditional operators

❌ NEVER: Returning null for collections
✅ ALWAYS: Return empty collections instead of null
```

### LINQ Usage
```csharp
❌ NEVER: Multiple enumeration of IEnumerable
✅ ALWAYS: Materialize with ToList() or ToArray() when needed

❌ NEVER: Complex LINQ in loops
✅ ALWAYS: Extract complex queries to methods

❌ NEVER: LINQ for side effects
✅ ALWAYS: Use foreach for operations with side effects
```

## Examples

### ✅ Good: Modern C# Patterns
```csharp
public class UserService : IUserService
{
    private readonly IUserRepository _userRepository;
    private readonly ILogger<UserService> _logger;
    
    public UserService(IUserRepository userRepository, ILogger<UserService> logger)
    {
        _userRepository = userRepository ?? throw new ArgumentNullException(nameof(userRepository));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
    
    public async Task<UserDto?> GetUserByIdAsync(int userId, CancellationToken cancellationToken = default)
    {
        try
        {
            var user = await _userRepository
                .GetByIdAsync(userId, cancellationToken)
                .ConfigureAwait(false);
                
            return user?.ToDto();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving user {UserId}", userId);
            throw;
        }
    }
    
    public async Task<IReadOnlyList<UserDto>> GetActiveUsersAsync(CancellationToken cancellationToken = default)
    {
        var users = await _userRepository
            .GetActiveUsersAsync(cancellationToken)
            .ConfigureAwait(false);
            
        return users
            .Select(u => u.ToDto())
            .ToList();
    }
}
```

### ❌ Bad: Anti-patterns
```csharp
public class user_service  // Wrong naming
{
    private IUserRepository repo;  // Abbreviation
    
    public async void GetUser(int id)  // async void
    {
        var user = repo.GetByIdAsync(id).Result;  // Blocking on async
        
        if (user == null)
            throw new NullReferenceException();  // Don't throw NRE
    }
    
    public List<UserDto> GetUsers()
    {
        var users = repo.GetAll();  // Not async
        
        // Multiple enumeration
        if (users.Any())
        {
            return users.Select(u => new UserDto()).ToList();
        }
        
        return null;  // Returning null for collection
    }
}
```

## Integration
This pattern validates:
- C# naming conventions
- Async/await best practices
- Null safety patterns
- LINQ usage patterns
- Modern C# features usage