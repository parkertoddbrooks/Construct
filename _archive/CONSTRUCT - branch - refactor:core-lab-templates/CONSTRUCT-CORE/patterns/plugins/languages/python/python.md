# Python Language Patterns

## Overview
This pattern enforces Python best practices following PEP 8 and modern Python conventions.

## Rules

### Code Style
```python
❌ NEVER: camelCase for functions and variables
✅ ALWAYS: snake_case for functions and variables

❌ NEVER: Tabs for indentation
✅ ALWAYS: 4 spaces for indentation

❌ NEVER: Lines longer than 120 characters
✅ ALWAYS: Break long lines appropriately
```

### Type Hints
```python
❌ NEVER: Missing type hints in new code
✅ ALWAYS: Use type hints for function signatures

❌ NEVER: Using strings for type hints (except forward references)
✅ ALWAYS: Import types from typing module

❌ NEVER: Ignoring mypy errors
✅ ALWAYS: Fix type issues properly
```

### Error Handling
```python
❌ NEVER: Bare except clauses
✅ ALWAYS: Catch specific exceptions

❌ NEVER: Pass in except blocks without comment
✅ ALWAYS: Handle errors appropriately or re-raise

❌ NEVER: Using assertions for validation
✅ ALWAYS: Proper validation with exceptions
```

### Modern Python Features
```python
❌ NEVER: String concatenation with +
✅ ALWAYS: Use f-strings for formatting

❌ NEVER: Manual file handling without context managers
✅ ALWAYS: Use with statements for resources

❌ NEVER: Mutable default arguments
✅ ALWAYS: Use None and create inside function
```

## Examples

### ✅ Good: Modern Python
```python
from typing import List, Optional, Dict
from dataclasses import dataclass
import logging

logger = logging.getLogger(__name__)

@dataclass
class User:
    """Represents a user in the system."""
    id: int
    name: str
    email: str
    is_active: bool = True

class UserService:
    """Service for managing users."""
    
    def __init__(self, repository: UserRepository) -> None:
        self._repository = repository
    
    async def get_user_by_id(self, user_id: int) -> Optional[User]:
        """Retrieve a user by their ID.
        
        Args:
            user_id: The ID of the user to retrieve
            
        Returns:
            The user if found, None otherwise
        """
        try:
            user_data = await self._repository.find_by_id(user_id)
            return User(**user_data) if user_data else None
        except DatabaseError as e:
            logger.error(f"Database error retrieving user {user_id}: {e}")
            raise
    
    def get_active_users(self, limit: Optional[int] = None) -> List[User]:
        """Get all active users with optional limit."""
        users = [
            User(**data) 
            for data in self._repository.find_active()
        ]
        
        if limit is not None:
            return users[:limit]
        return users
```

### ❌ Bad: Anti-patterns
```python
class userService:  # Wrong naming (camelCase)
    
    def getUser(self, id):  # No type hints
        try:
            user = self.repository.find(id)
        except:  # Bare except
            pass  # Silent failure
            
        # String concatenation
        message = "User " + str(id) + " retrieved"
        
        # No return type
        return user
    
    def get_users(self, filters={}):  # Mutable default
        # Manual file handling
        f = open('users.txt', 'r')
        data = f.read()
        f.close()
        
        # Using assertion for validation
        assert len(data) > 0, "No data"
        
        # No proper error handling
        return eval(data)  # Security issue!
```

## Testing Patterns
```python
❌ NEVER: Tests without descriptive names
✅ ALWAYS: test_should_behavior_when_condition

❌ NEVER: Multiple assertions without clear sections
✅ ALWAYS: Arrange-Act-Assert pattern

❌ NEVER: Tests depending on external services
✅ ALWAYS: Mock external dependencies
```

## Integration
This pattern validates:
- PEP 8 compliance
- Type hint usage
- Modern Python features
- Error handling practices
- Security best practices