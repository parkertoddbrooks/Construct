# Web Platform Patterns

## Progressive Web App (PWA) Patterns

### ✅ DO: Service Worker Best Practices
```javascript
// Service worker with versioning and cleanup
const CACHE_VERSION = 'v1.2.3';
const CACHE_NAME = `app-${CACHE_VERSION}`;
const urlsToCache = [
  '/',
  '/styles/main.css',
  '/scripts/main.js',
  '/offline.html'
];

// Install and cache essential resources
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(urlsToCache))
      .then(() => self.skipWaiting())
  );
});

// Clean up old caches
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(name => name.startsWith('app-') && name !== CACHE_NAME)
          .map(name => caches.delete(name))
      );
    }).then(() => self.clients.claim())
  );
});

// Network-first with cache fallback
self.addEventListener('fetch', event => {
  event.respondWith(
    fetch(event.request)
      .then(response => {
        // Cache successful responses
        if (response.ok && event.request.method === 'GET') {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => {
            cache.put(event.request, responseClone);
          });
        }
        return response;
      })
      .catch(() => {
        // Fall back to cache
        return caches.match(event.request)
          .then(response => response || caches.match('/offline.html'));
      })
  );
});
```

### ✅ DO: Web App Manifest
```json
{
  "name": "My Progressive Web App",
  "short_name": "MyPWA",
  "description": "A fast, reliable web app",
  "start_url": "/?source=pwa",
  "display": "standalone",
  "orientation": "portrait",
  "theme_color": "#2196F3",
  "background_color": "#ffffff",
  "icons": [
    {
      "src": "/icons/icon-192.png",
      "sizes": "192x192",
      "type": "image/png",
      "purpose": "any maskable"
    },
    {
      "src": "/icons/icon-512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ],
  "shortcuts": [
    {
      "name": "New Order",
      "url": "/orders/new",
      "icons": [{ "src": "/icons/new-order.png", "sizes": "96x96" }]
    }
  ]
}
```

## SEO Patterns

### ✅ DO: Complete Meta Tags
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <!-- Essential Meta Tags -->
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Page Title - Site Name</title>
  <meta name="description" content="A compelling description under 155 characters that includes relevant keywords naturally.">
  
  <!-- Open Graph for Social -->
  <meta property="og:type" content="website">
  <meta property="og:title" content="Page Title">
  <meta property="og:description" content="Description for social sharing">
  <meta property="og:image" content="https://example.com/og-image.jpg">
  <meta property="og:url" content="https://example.com/page">
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
  <meta name="twitter:title" content="Page Title">
  <meta name="twitter:description" content="Description for Twitter">
  <meta name="twitter:image" content="https://example.com/twitter-image.jpg">
  
  <!-- Canonical URL -->
  <link rel="canonical" href="https://example.com/page">
  
  <!-- Structured Data -->
  <script type="application/ld+json">
  {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "name": "Page Title",
    "description": "Page description",
    "url": "https://example.com/page",
    "author": {
      "@type": "Organization",
      "name": "Company Name"
    }
  }
  </script>
</head>
```

### ✅ DO: Dynamic Sitemap Generation
```javascript
// Generate sitemap.xml dynamically
async function generateSitemap() {
  const pages = await getAllPages();
  
  const sitemap = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
${pages.map(page => `  <url>
    <loc>${page.url}</loc>
    <lastmod>${page.lastModified}</lastmod>
    <changefreq>${page.changeFreq}</changefreq>
    <priority>${page.priority}</priority>
  </url>`).join('\n')}
</urlset>`;
  
  return sitemap;
}
```

## Browser API Patterns

### ✅ DO: Progressive Enhancement
```javascript
// Feature detection with fallbacks
class StorageManager {
  async save(key, value) {
    // Try IndexedDB first
    if ('indexedDB' in window) {
      try {
        await this.saveToIndexedDB(key, value);
        return;
      } catch (e) {
        console.warn('IndexedDB failed:', e);
      }
    }
    
    // Fall back to localStorage
    if ('localStorage' in window) {
      try {
        localStorage.setItem(key, JSON.stringify(value));
        return;
      } catch (e) {
        console.warn('localStorage failed:', e);
      }
    }
    
    // Final fallback to cookies
    document.cookie = `${key}=${encodeURIComponent(JSON.stringify(value))}; path=/`;
  }
}
```

### ✅ DO: Permissions API
```javascript
// Request permissions properly
async function requestNotifications() {
  // Check if API is available
  if (!('Notification' in window)) {
    console.log('Notifications not supported');
    return false;
  }
  
  // Check current permission
  if (Notification.permission === 'granted') {
    return true;
  }
  
  // Request permission with context
  if (Notification.permission !== 'denied') {
    const permission = await Notification.requestPermission();
    return permission === 'granted';
  }
  
  return false;
}

// Use permissions
async function sendNotification(title, options) {
  const hasPermission = await requestNotifications();
  
  if (hasPermission) {
    const notification = new Notification(title, {
      body: options.body,
      icon: '/icons/notification.png',
      badge: '/icons/badge.png',
      tag: options.tag || 'default',
      requireInteraction: false,
      ...options
    });
    
    notification.onclick = () => {
      window.focus();
      notification.close();
    };
  }
}
```

## Performance Patterns

### ✅ DO: Resource Hints
```html
<!-- DNS Prefetch for external domains -->
<link rel="dns-prefetch" href="https://api.example.com">
<link rel="dns-prefetch" href="https://cdn.example.com">

<!-- Preconnect for critical origins -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- Preload critical resources -->
<link rel="preload" href="/fonts/main.woff2" as="font" type="font/woff2" crossorigin>
<link rel="preload" href="/css/critical.css" as="style">
<link rel="preload" href="/js/main.js" as="script">

<!-- Prefetch next page resources -->
<link rel="prefetch" href="/next-page.html">
<link rel="prefetch" href="/css/next-page.css">
```

### ✅ DO: Responsive Images
```html
<!-- Picture element with multiple formats -->
<picture>
  <source 
    type="image/avif" 
    srcset="image-300.avif 300w, image-600.avif 600w, image-1200.avif 1200w"
    sizes="(max-width: 600px) 100vw, (max-width: 1200px) 50vw, 600px">
  <source 
    type="image/webp" 
    srcset="image-300.webp 300w, image-600.webp 600w, image-1200.webp 1200w"
    sizes="(max-width: 600px) 100vw, (max-width: 1200px) 50vw, 600px">
  <img 
    src="image-600.jpg" 
    srcset="image-300.jpg 300w, image-600.jpg 600w, image-1200.jpg 1200w"
    sizes="(max-width: 600px) 100vw, (max-width: 1200px) 50vw, 600px"
    alt="Descriptive text"
    loading="lazy"
    decoding="async"
    width="600"
    height="400">
</picture>
```

## Web Storage Patterns

### ✅ DO: Storage Quota Management
```javascript
// Check storage availability and quota
async function checkStorageQuota() {
  if ('storage' in navigator && 'estimate' in navigator.storage) {
    const {usage, quota} = await navigator.storage.estimate();
    const percentUsed = (usage / quota) * 100;
    
    console.log(`Storage used: ${usage} of ${quota} bytes (${percentUsed.toFixed(2)}%)`);
    
    // Warn if getting close to quota
    if (percentUsed > 80) {
      console.warn('Storage quota nearly exhausted');
      await cleanupOldData();
    }
    
    return { usage, quota, percentUsed };
  }
  
  return null;
}

// Request persistent storage
async function requestPersistentStorage() {
  if ('storage' in navigator && 'persist' in navigator.storage) {
    const isPersisted = await navigator.storage.persist();
    console.log(`Storage persisted: ${isPersisted}`);
    return isPersisted;
  }
  return false;
}
```

## Network Information API

### ✅ DO: Adaptive Loading
```javascript
// Adjust behavior based on network conditions
function getNetworkAwareConfig() {
  const connection = navigator.connection || 
                    navigator.mozConnection || 
                    navigator.webkitConnection;
  
  if (!connection) {
    return { quality: 'high', preload: true };
  }
  
  // Check effective connection type
  if (connection.effectiveType === '4g' && !connection.saveData) {
    return {
      quality: 'high',
      preload: true,
      videoAutoplay: true,
      imageQuality: 'high'
    };
  }
  
  if (connection.effectiveType === '3g' || connection.saveData) {
    return {
      quality: 'medium',
      preload: false,
      videoAutoplay: false,
      imageQuality: 'medium'
    };
  }
  
  // 2g or slow-2g
  return {
    quality: 'low',
    preload: false,
    videoAutoplay: false,
    imageQuality: 'low'
  };
}

// Listen for network changes
if ('connection' in navigator) {
  navigator.connection.addEventListener('change', () => {
    const config = getNetworkAwareConfig();
    updateAppConfig(config);
  });
}
```

## Intersection Observer Patterns

### ✅ DO: Efficient Element Tracking
```javascript
// Lazy loading with Intersection Observer
class LazyLoader {
  constructor() {
    this.imageObserver = new IntersectionObserver(
      (entries) => this.handleIntersection(entries),
      {
        rootMargin: '50px', // Start loading 50px before visible
        threshold: 0.01
      }
    );
  }
  
  handleIntersection(entries) {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        const img = entry.target;
        
        // Load image
        if (img.dataset.src) {
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
        }
        
        // Load srcset
        if (img.dataset.srcset) {
          img.srcset = img.dataset.srcset;
          img.removeAttribute('data-srcset');
        }
        
        // Stop observing
        this.imageObserver.unobserve(img);
      }
    });
  }
  
  observe(selector = 'img[data-src]') {
    const images = document.querySelectorAll(selector);
    images.forEach(img => this.imageObserver.observe(img));
  }
  
  disconnect() {
    this.imageObserver.disconnect();
  }
}

// Analytics tracking with Intersection Observer
class ViewportTracker {
  constructor() {
    this.tracked = new Set();
    this.observer = new IntersectionObserver(
      (entries) => this.trackVisibility(entries),
      {
        threshold: [0, 0.25, 0.5, 0.75, 1.0]
      }
    );
  }
  
  trackVisibility(entries) {
    entries.forEach(entry => {
      const id = entry.target.id;
      const visibility = Math.round(entry.intersectionRatio * 100);
      
      if (visibility >= 50 && !this.tracked.has(id)) {
        this.tracked.add(id);
        analytics.track('Element Viewed', {
          elementId: id,
          visibility: visibility
        });
      }
    });
  }
}
```

## Web Share API

### ✅ DO: Native Sharing
```javascript
// Progressive enhancement for sharing
async function shareContent(data) {
  // Check if Web Share API is available
  if (navigator.share && navigator.canShare && navigator.canShare(data)) {
    try {
      await navigator.share(data);
      analytics.track('Content Shared', { method: 'native' });
      return true;
    } catch (err) {
      if (err.name !== 'AbortError') {
        console.error('Share failed:', err);
      }
    }
  }
  
  // Fallback to custom share UI
  showCustomShareDialog(data);
  return false;
}

// Share with files
async function shareWithFiles(files, text) {
  const data = {
    title: 'Check this out',
    text: text,
    files: files
  };
  
  if (navigator.canShare && navigator.canShare(data)) {
    await navigator.share(data);
  } else {
    // Fallback for file sharing
    showFileShareFallback(files, text);
  }
}
```

## Payment Request API

### ✅ DO: Streamlined Checkout
```javascript
// Modern payment handling
async function handlePayment(orderDetails) {
  if (!window.PaymentRequest) {
    // Fallback to traditional checkout
    return traditionalCheckout(orderDetails);
  }
  
  const supportedMethods = [{
    supportedMethods: 'basic-card',
    data: {
      supportedNetworks: ['visa', 'mastercard', 'amex'],
      supportedTypes: ['credit', 'debit']
    }
  }];
  
  const details = {
    total: {
      label: 'Total',
      amount: {
        currency: 'USD',
        value: orderDetails.total
      }
    },
    displayItems: orderDetails.items.map(item => ({
      label: item.name,
      amount: {
        currency: 'USD',
        value: item.price
      }
    }))
  };
  
  const options = {
    requestPayerName: true,
    requestPayerEmail: true,
    requestShipping: true
  };
  
  try {
    const request = new PaymentRequest(supportedMethods, details, options);
    const response = await request.show();
    
    // Process payment
    const result = await processPayment(response);
    await response.complete(result.success ? 'success' : 'fail');
    
    return result;
  } catch (err) {
    console.error('Payment failed:', err);
    return traditionalCheckout(orderDetails);
  }
}
```