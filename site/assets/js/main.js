/**
 * ChristianFindlay.com - Main JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
  // Initialize navigation
  initNavigation();

  // Initialize syntax highlighting
  initSyntaxHighlighting();

  // Add copy button to code blocks
  addCopyButtons();

  // Initialize smooth scrolling
  initSmoothScrolling();

  // Initialize owl carousel
  initOwlCarousel();

  // Remove duplicate elements
  function removeDuplicateElements() {
    // Remove any duplicate navigation and problematic elements
    const removeSelectors = [
      '.one-page-nav', 
      '#ChristianFindlay-com', 
      '.ChristianFindlay-com',
      '[id*="ChristianFindlay"]',
      '.location',
      '.more',
      'img[alt="x"]',
      'a > img[alt="x"]',
      '.content-wrapper > div > a:not(.nav-link)',
      'nav:not(#main-nav)'
    ];
    
    removeSelectors.forEach(function(selector) {
      try {
        const elements = document.querySelectorAll(selector);
        elements.forEach(function(el) {
          el.remove();
        });
      } catch (e) {
        console.warn('Error removing elements:', selector, e);
      }
    });
  }
  
  // Fix containers and layout
  function fixContainers() {
    const wrappers = document.querySelectorAll('.wrapper');
    wrappers.forEach(function(wrapper) {
      // Check if wrapper already has a container
      if (!wrapper.querySelector(':scope > .container')) {
        const container = document.createElement('div');
        container.className = 'container';
        // Move all children into the container
        while (wrapper.firstChild) {
          container.appendChild(wrapper.firstChild);
        }
        wrapper.appendChild(container);
      }
    });
  }
  
  // Set active navigation links
  function setActiveNavLinks() {
    const currentPath = document.body.getAttribute('data-path');
    if (!currentPath) return;
    
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(function(link) {
      const linkPath = link.getAttribute('data-path');
      if (!linkPath) return;
      
      // Exact match for home
      if (linkPath === '/' && currentPath === '/') {
        link.classList.add('active');
      }
      // Match for other pages (including sub-pages)
      else if (linkPath !== '/' && currentPath && currentPath.startsWith(linkPath)) {
        link.classList.add('active');
      }
      // Special case for blog posts
      else if (linkPath === '/blog/' && currentPath && currentPath.includes('/20')) {
        link.classList.add('active');
      }
    });
  }
  
  // Fix the blog grid if it exists
  function fixBlogGrid() {
    const blogGrid = document.querySelector('.blog.grid');
    if (!blogGrid) return;
    
    // Clear any existing layout classes that might conflict
    blogGrid.classList.add('grid-fixed');
    
    // Ensure proper display for the row and isotope elements inside
    const rowsAndIsotope = blogGrid.querySelectorAll('.row, .isotope');
    rowsAndIsotope.forEach(function(element) {
      element.style.display = 'contents';
      element.style.width = '100%';
    });
    
    // Fix the grid items
    const items = blogGrid.querySelectorAll('.item, .post');
    items.forEach(function(item) {
      item.style.width = '100%';
      item.style.position = 'static';
      item.style.left = 'auto';
      item.style.top = 'auto';
    });
  }
  
  // Fix post styling
  function fixPosts() {
    // Fix any posts
    const posts = document.querySelectorAll('.post');
    posts.forEach(function(post) {
      // Add styling to make posts look better
      post.classList.add('post-fixed');
      
      // Fix post content padding if needed
      const postContent = post.querySelector('.post-content');
      if (postContent) {
        postContent.classList.add('post-content-fixed');
      }
      
      // Fix post images if they exist
      const postFigure = post.querySelector('figure');
      if (postFigure) {
        postFigure.classList.add('post-figure-fixed');
      }
    });
  }
  
  // Fix sidebar styling
  function fixSidebar() {
    const sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;
    
    sidebar.classList.add('sidebar-fixed');
    
    // Fix sidebar widgets
    const widgets = sidebar.querySelectorAll('.widget');
    widgets.forEach(function(widget) {
      widget.classList.add('widget-fixed');
    });
  }
  
  // Add class to body based on the current page
  function setBodyClass() {
    const currentPath = document.body.getAttribute('data-path');
    if (!currentPath) return;
    
    if (currentPath === '/') {
      document.body.classList.add('home-page');
    } else if (currentPath.includes('/blog/')) {
      document.body.classList.add('blog-page');
    } else if (currentPath.includes('/20')) {
      document.body.classList.add('post-page');
    }
  }
  
  // Initialize all fixes
  function initFixes() {
    removeDuplicateElements();
    fixContainers();
    setActiveNavLinks();
    fixBlogGrid();
    fixPosts();
    fixSidebar();
    setBodyClass();
    
    // Set up mutation observer to continuously clean the DOM
    const observer = new MutationObserver(function() {
      removeDuplicateElements();
    });
    
    observer.observe(document.body, { 
      childList: true,
      subtree: true
    });
  }
  
  // Run all the fixes
  initFixes();
});

/**
 * Handle navigation functionality
 */
function initNavigation() {
  // Set active navigation links
  const currentPath = document.body.getAttribute('data-path');
  const navLinks = document.querySelectorAll('.nav-link');
  
  if (!currentPath) return;
  
  navLinks.forEach(function(link) {
    const linkPath = link.getAttribute('data-path');
    
    // Handle active states
    if (linkPath === '/' && currentPath === '/') {
      link.classList.add('active');
    } 
    else if (linkPath !== '/' && currentPath.startsWith(linkPath)) {
      link.classList.add('active');
    }
    // Special case for blog posts
    else if (linkPath === '/blog/' && currentPath.includes('/20')) {
      link.classList.add('active');
    }
  });
  
  // Remove any duplicate navigation systems
  const duplicateNavs = document.querySelectorAll('.one-page-nav, nav:not(#main-nav)');
  duplicateNavs.forEach(function(nav) {
    nav.style.display = 'none';
  });
}

/**
 * Initialize code syntax highlighting
 */
function initSyntaxHighlighting() {
  document.querySelectorAll('pre.highlight').forEach(pre => {
    // Apply styling to code blocks
    pre.style.backgroundColor = '#1e293b';
    pre.style.color = '#e4e4e7';
    pre.style.borderRadius = '0.5rem';
    pre.style.padding = '1rem';
    pre.style.overflow = 'auto';
    pre.style.margin = '1.5rem 0';
    
    const code = pre.querySelector('code');
    if (code) {
      // Set language indicator
      const language = code.className.match(/language-(\w+)/);
      if (language) {
        const langLabel = document.createElement('div');
        langLabel.className = 'code-lang-label';
        langLabel.textContent = language[1].toUpperCase();
        langLabel.style.position = 'absolute';
        langLabel.style.top = '0';
        langLabel.style.right = '0';
        langLabel.style.padding = '0.2rem 0.6rem';
        langLabel.style.fontSize = '0.7rem';
        langLabel.style.fontWeight = '600';
        langLabel.style.color = 'rgba(228, 228, 231, 0.7)';
        langLabel.style.backgroundColor = 'rgba(255, 255, 255, 0.05)';
        langLabel.style.borderBottomLeftRadius = '0.25rem';
        
        // Make sure pre is positioned relative
        pre.style.position = 'relative';
        pre.appendChild(langLabel);
      }
    }
  });
}

/**
 * Add copy buttons to code blocks
 */
function addCopyButtons() {
  document.querySelectorAll('pre.highlight').forEach(pre => {
    // Create copy button
    const copyButton = document.createElement('button');
    copyButton.className = 'copy-button';
    copyButton.innerHTML = 'Copy';
    copyButton.style.position = 'absolute';
    copyButton.style.top = '0';
    copyButton.style.right = '0';
    copyButton.style.padding = '0.2rem 0.6rem';
    copyButton.style.margin = '0.3rem';
    copyButton.style.fontSize = '0.75rem';
    copyButton.style.fontWeight = '500';
    copyButton.style.color = 'rgba(228, 228, 231, 0.7)';
    copyButton.style.backgroundColor = 'rgba(255, 255, 255, 0.1)';
    copyButton.style.border = 'none';
    copyButton.style.borderRadius = '0.25rem';
    copyButton.style.cursor = 'pointer';
    copyButton.style.zIndex = '10';
    
    // Make sure pre is positioned relative
    pre.style.position = 'relative';
    
    // Add copy functionality
    copyButton.addEventListener('click', () => {
      const code = pre.querySelector('code');
      if (code) {
        navigator.clipboard.writeText(code.innerText).then(() => {
          copyButton.innerHTML = 'Copied!';
          setTimeout(() => {
            copyButton.innerHTML = 'Copy';
          }, 2000);
        });
      }
    });
    
    pre.appendChild(copyButton);
  });
}

/**
 * Initialize smooth scrolling for anchor links
 */
function initSmoothScrolling() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      const targetId = this.getAttribute('href');
      
      if (targetId === '#') return;
      
      const targetElement = document.getElementById(targetId.substring(1));
      if (!targetElement) return;
      
      e.preventDefault();
      
      window.scrollTo({
        top: targetElement.offsetTop - 80, // Account for fixed header
        behavior: 'smooth'
      });
      
      // Update URL without jumping
      history.pushState(null, null, targetId);
    });
  });
}

/**
 * Initialize Owl Carousel for the "You Might Also Like" section
 */
function initOwlCarousel() {
  if (typeof $.fn.owlCarousel === 'undefined') {
    console.warn('Owl Carousel plugin not found');
    return;
  }

  $('.owl-carousel').each(function() {
    const $carousel = $(this);
    
    // Get data attributes
    const margin = $carousel.data('margin') || 30;
    const dots = $carousel.data('dots') !== undefined ? $carousel.data('dots') : true;
    const autoplay = $carousel.data('autoplay') !== undefined ? $carousel.data('autoplay') : false;
    const autoplayTimeout = $carousel.data('autoplay-timeout') || 5000;
    const responsive = $carousel.data('responsive') || {
      "0": { "items": 1 },
      "768": { "items": 2 },
      "992": { "items": 3 }
    };
    
    // Initialize carousel
    $carousel.owlCarousel({
      margin: margin,
      nav: false,
      dots: dots,
      autoplay: autoplay,
      autoplayTimeout: autoplayTimeout,
      responsive: responsive,
      loop: false,
      rewind: true,
      onInitialized: fixCarouselHeight,
      onResized: fixCarouselHeight,
      onTranslated: fixCarouselHeight
    });
    
    // Fix carousel height on initialization
    function fixCarouselHeight(event) {
      const items = $carousel.find('.owl-item');
      items.height('auto');
      
      // Find the maximum height
      let maxHeight = 0;
      items.each(function() {
        const height = $(this).height();
        maxHeight = Math.max(maxHeight, height);
      });
      
      // Set equal height to all items
      if (maxHeight > 0) {
        items.height(maxHeight);
      }
    }
  });
} 