# Web Framework Patterns

## Core Web Development Rules

### ✅ DO: Security First
- **Sanitize all user inputs** - Never trust data from users
- **Use HTTPS everywhere** - No mixed content
- **Implement CSP headers** - Content Security Policy prevents XSS
- **Validate on both client AND server** - Client validation is just UX
- **Store secrets server-side only** - Never expose API keys in frontend
- **Use SameSite cookies** - Protect against CSRF attacks
- **Implement rate limiting** - Prevent abuse and DDoS

### ✅ DO: Performance Patterns
- **Lazy load below the fold** - Don't load what users can't see
- **Bundle splitting by route** - Load only what's needed per page
- **Image optimization** - WebP with fallbacks, responsive sizes
- **Critical CSS inline** - Above-the-fold styles in HTML
- **Debounce expensive operations** - Search, resize, scroll handlers
- **Use web workers for heavy computation** - Keep main thread responsive
- **Cache API responses** - Reduce redundant network requests

### ✅ DO: Accessibility (a11y)
- **Semantic HTML first** - Use proper elements before ARIA
- **Keyboard navigation** - Everything mouse can do, keyboard can too
- **Screen reader testing** - Not just automated tools
- **Color contrast ratios** - WCAG AA minimum (4.5:1)
- **Focus indicators** - Visible and meaningful
- **Alt text for images** - Descriptive, not redundant
- **ARIA labels for icons** - Screen readers need context

### ❌ DON'T: Common Anti-patterns
- Inline styles in production (use CSS classes)
- JavaScript for layout (CSS Grid/Flexbox instead)
- Blocking render with scripts (use async/defer)
- Storing sensitive data in localStorage
- Using `div` for interactive elements (use `button`)
- Assuming JavaScript is available (progressive enhancement)
- Infinite scroll without escape (trap keyboard users)
- Autoplaying media with sound
- Hijacking scroll behavior without user consent

## State Management Patterns

### Client State vs Server State
```javascript
// ✅ GOOD: Separate concerns
const clientState = {
  isMenuOpen: false,
  selectedTab: 'overview',
  formErrors: {},
  theme: 'light'
};

const serverState = {
  user: { id: 123, name: 'Alice' },
  products: [/* from API */],
  orders: [/* from API */],
  lastSync: Date.now()
};

// ❌ BAD: Mixed state causes confusion
const appState = {
  isMenuOpen: false,  // UI state
  user: {},           // Server state
  products: [],       // Server state
  selectedTab: 0      // UI state
};
```

### State Update Patterns
```javascript
// ✅ GOOD: Immutable updates
function updateUser(state, updates) {
  return {
    ...state,
    user: {
      ...state.user,
      ...updates
    }
  };
}

// ❌ BAD: Mutating state directly
function updateUser(state, updates) {
  state.user = updates;  // Mutation!
  return state;
}
```

## API Integration Patterns

### Proper Error Handling
```javascript
// ✅ GOOD: Comprehensive error handling
async function fetchData(endpoint, options = {}) {
  const controller = new AbortController();
  const timeoutId = setTimeout(() => controller.abort(), 10000); // 10s timeout
  
  try {
    const response = await fetch(endpoint, {
      ...options,
      signal: controller.signal
    });
    
    clearTimeout(timeoutId);
    
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    
    const data = await response.json();
    return { data, error: null };
    
  } catch (error) {
    clearTimeout(timeoutId);
    
    // Differentiate error types
    if (error.name === 'AbortError') {
      return { data: null, error: { type: 'timeout', message: 'Request timeout' } };
    }
    
    if (!navigator.onLine) {
      return { data: null, error: { type: 'network', message: 'No internet connection' } };
    }
    
    return { 
      data: null, 
      error: {
        type: 'unknown',
        message: error.message,
        timestamp: Date.now()
      }
    };
  }
}
```

### Request Deduplication
```javascript
// ✅ GOOD: Prevent duplicate requests
const pendingRequests = new Map();

async function fetchWithDedup(url) {
  if (pendingRequests.has(url)) {
    return pendingRequests.get(url);
  }
  
  const promise = fetch(url)
    .then(res => res.json())
    .finally(() => pendingRequests.delete(url));
    
  pendingRequests.set(url, promise);
  return promise;
}
```

## Component Patterns

### Composition over Inheritance
```javascript
// ✅ GOOD: Composable components
function Card({ children, className = '', ...props }) {
  return (
    <div className={`card ${className}`} {...props}>
      {children}
    </div>
  );
}

function ProfileCard({ user }) {
  return (
    <Card className="profile-card" data-user-id={user.id}>
      <CardHeader title={user.name} subtitle={user.role} />
      <CardBody>
        <p>{user.bio}</p>
      </CardBody>
      <CardFooter>
        <FollowButton userId={user.id} />
        <ShareButton url={`/users/${user.id}`} />
      </CardFooter>
    </Card>
  );
}
```

### Error Boundaries
```javascript
// ✅ GOOD: Graceful error handling
class ErrorBoundary extends Component {
  state = { hasError: false, error: null };
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Component error:', error, errorInfo);
    // Send to error tracking service
  }
  
  render() {
    if (this.state.hasError) {
      return (
        <div className="error-fallback">
          <h2>Something went wrong</h2>
          <button onClick={() => this.setState({ hasError: false })}>
            Try again
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

## Form Handling Patterns

### Controlled Forms with Validation
```javascript
// ✅ GOOD: Comprehensive form handling
function useForm(initialValues, validate) {
  const [values, setValues] = useState(initialValues);
  const [errors, setErrors] = useState({});
  const [touched, setTouched] = useState({});
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const handleChange = (name, value) => {
    setValues(prev => ({ ...prev, [name]: value }));
    
    // Clear error when user types
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: null }));
    }
  };
  
  const handleBlur = (name) => {
    setTouched(prev => ({ ...prev, [name]: true }));
    
    // Validate on blur
    const fieldError = validate({ [name]: values[name] })[name];
    if (fieldError) {
      setErrors(prev => ({ ...prev, [name]: fieldError }));
    }
  };
  
  const handleSubmit = async (onSubmit) => {
    setIsSubmitting(true);
    
    // Validate all fields
    const validationErrors = validate(values);
    setErrors(validationErrors);
    
    if (Object.keys(validationErrors).length === 0) {
      try {
        await onSubmit(values);
      } catch (error) {
        console.error('Submit error:', error);
      }
    }
    
    setIsSubmitting(false);
  };
  
  return {
    values,
    errors,
    touched,
    isSubmitting,
    handleChange,
    handleBlur,
    handleSubmit
  };
}
```

## Build & Deploy Patterns

### Environment Configuration
```javascript
// ✅ GOOD: Environment-specific config
const config = {
  development: {
    apiUrl: 'http://localhost:3000/api',
    enableDebug: true,
    mockData: true,
    logLevel: 'debug'
  },
  staging: {
    apiUrl: 'https://staging-api.example.com',
    enableDebug: true,
    mockData: false,
    logLevel: 'info'
  },
  production: {
    apiUrl: 'https://api.example.com',
    enableDebug: false,
    mockData: false,
    logLevel: 'error'
  }
}[process.env.NODE_ENV || 'development'];

// Export frozen config to prevent mutations
export default Object.freeze(config);
```

### Feature Flags
```javascript
// ✅ GOOD: Safe feature rollout
const features = {
  newCheckout: process.env.FEATURE_NEW_CHECKOUT === 'true',
  darkMode: process.env.FEATURE_DARK_MODE === 'true',
  socialLogin: process.env.FEATURE_SOCIAL_LOGIN === 'true'
};

function FeatureFlag({ feature, children, fallback = null }) {
  if (features[feature]) {
    return children;
  }
  return fallback;
}

// Usage
<FeatureFlag feature="newCheckout" fallback={<OldCheckout />}>
  <NewCheckout />
</FeatureFlag>
```

## Testing Patterns

### Component Testing
```javascript
// ✅ GOOD: Test user behavior, not implementation
test('user can submit form with valid data', async () => {
  const onSubmit = jest.fn();
  const { getByLabelText, getByRole } = render(
    <ContactForm onSubmit={onSubmit} />
  );
  
  // User fills form
  await userEvent.type(getByLabelText('Name'), 'John Doe');
  await userEvent.type(getByLabelText('Email'), 'john@example.com');
  await userEvent.type(getByLabelText('Message'), 'Hello world');
  
  // User submits
  await userEvent.click(getByRole('button', { name: 'Send' }));
  
  // Verify behavior
  expect(onSubmit).toHaveBeenCalledWith({
    name: 'John Doe',
    email: 'john@example.com',
    message: 'Hello world'
  });
});
```

## Performance Monitoring

### Core Web Vitals
```javascript
// ✅ GOOD: Monitor real user metrics
function reportWebVitals(onReport) {
  if ('web-vital' in window) {
    import('web-vitals').then(({ getCLS, getFID, getFCP, getLCP, getTTFB }) => {
      getCLS(onReport);   // Cumulative Layout Shift
      getFID(onReport);   // First Input Delay
      getFCP(onReport);   // First Contentful Paint
      getLCP(onReport);   // Largest Contentful Paint
      getTTFB(onReport);  // Time to First Byte
    });
  }
}

// Send to analytics
reportWebVitals(metric => {
  analytics.track('Web Vitals', {
    name: metric.name,
    value: metric.value,
    rating: metric.rating
  });
});
```