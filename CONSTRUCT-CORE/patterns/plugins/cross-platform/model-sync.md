# [CROSS-PLATFORM] Model Synchronization

## When to Use
- When working with data models that exist across multiple languages/platforms
- When updating APIs that affect multiple client implementations
- When coordinating changes across full-stack applications

## Model Change Checklist

When updating any data model, consider ALL representations:

### ✅ DO: Complete Model Updates
- [ ] Update backend model (C#/Python/Node.js/etc.)
- [ ] Update database schema/migration
- [ ] Update API DTOs/contracts
- [ ] Update frontend models (Swift/TypeScript/Kotlin/etc.)
- [ ] Update API client code
- [ ] Update tests across all platforms
- [ ] Update API documentation/OpenAPI spec
- [ ] Consider backward compatibility

### ✅ DO: Validation Across Stack
- Verify serialization compatibility between all layers
- Test API contracts work with all client implementations
- Ensure database constraints align with model rules
- Validate type mappings between languages

## Common Change Patterns

### 1. Adding a Field
**Impact**: Propagates through entire stack
**Considerations**:
- Backend: Add field with appropriate default value
- Database: Migration with default or nullable
- API: Update DTOs, ensure backward compatibility
- Clients: Update models, handle missing field gracefully
- Tests: Update all model-related tests

### 2. Renaming a Field
**Impact**: Breaking change requiring API versioning
**Considerations**:
- Plan migration strategy
- Consider supporting both old and new names temporarily
- Update API documentation with deprecation notices
- Coordinate client updates

### 3. Removing a Field
**Impact**: Breaking change, check for dependencies
**Considerations**:
- Audit all usages across platforms
- Deprecate before removing
- Ensure no client code depends on the field
- Update database to remove column safely

### 4. Type Changes
**Impact**: Potential serialization issues
**Considerations**:
- Validate serialization compatibility
- Test edge cases and boundary values
- Consider data migration needs
- Update validation rules consistently

## Language-Specific Considerations

### Swift/iOS Models
```swift
// Codable properties for API compatibility
struct User: Codable {
    let id: UUID
    let email: String
    let profilePictureURL: String?  // Optional for backward compatibility
}
```

### C#/.NET Models
```csharp
// Entity and DTO separation
public class User 
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string? ProfilePictureUrl { get; set; }  // Nullable for compatibility
}
```

### TypeScript Models
```typescript
// Interface for type safety
interface User {
    id: string;
    email: string;
    profilePictureURL?: string;  // Optional for compatibility
}
```

## API Versioning Strategy

### ✅ DO: Version Management
- Use semantic versioning for API changes
- Maintain backward compatibility when possible
- Document breaking changes clearly
- Provide migration guides for major versions

### ✅ DO: Contract Testing
- Test API contracts across all client implementations
- Validate serialization/deserialization works correctly
- Ensure error responses are handled consistently
- Test edge cases and error conditions

## Cross-Platform Validation

### ✅ DO: Consistency Checks
- Model field names match across platforms (considering naming conventions)
- Data types are appropriately mapped
- Validation rules are consistent
- Error handling patterns align

### ✅ DO: Documentation Sync
- Keep API documentation updated with all changes
- Document platform-specific considerations
- Maintain examples for each client platform
- Update integration guides

## Integration Commands

When I detect multi-platform model updates, I'll guide through:
1. **Backend Changes**: Entity, DTO, validation, migration
2. **API Layer**: Contract updates, documentation, versioning
3. **Client Updates**: Model updates, API client changes, tests
4. **Database**: Schema changes, data migration, constraints
5. **Testing**: Integration tests, contract validation, edge cases

## Common Scenarios

### "Update User model everywhere"
I'll guide through updating the User model across your entire stack with appropriate considerations for each platform.

### "Add new field to Product"
I'll help ensure the new field is added consistently across backend, API, and all client implementations.

### "Change data type for timestamp"
I'll validate the type change works across all platforms and guide through necessary migrations.

## Integration
This pattern activates when:
- Mentioning models that exist across multiple platforms
- Requesting changes that affect multiple languages
- Working on API endpoints consumed by multiple clients
- Discussing database schema changes that affect client code