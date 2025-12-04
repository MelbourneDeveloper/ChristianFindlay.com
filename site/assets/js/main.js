/**
 * ChristianFindlay.com - Main JavaScript
 */
document.addEventListener('DOMContentLoaded', function() {
  // Initialize core functionality
  initNavigation();
  initSyntaxHighlighting();
  addCopyButtons();
  initSmoothScrolling();
  initOwlCarousel();
  optimizeContentWrappers();
  initTestimonials(); // Add specific testimonials initialization
  initPageTransitions(); // Fixed transitions that don't break nav menu
  
  //TODO: REMOVE THIS SHIT!! 
  //The dumbass LLM ignored the core problem and just 
  //patched it up like this FFS.

  // Initialize page transitions
  function initPageTransitions() {
    // Create transition overlay if it doesn't exist
    if (!document.querySelector('.page-transition-overlay')) {
      const overlay = document.createElement('div');
      overlay.className = 'page-transition-overlay';
      document.body.appendChild(overlay);
    }

    // Only add transitions to non-nav, non-navbar links that navigate within the site
    const blogLinks = document.querySelectorAll('.post-card-read-more, .pagination a');
    
    blogLinks.forEach(function(link) {
      link.addEventListener('click', function(e) {
        if (link.href && 
            link.href.indexOf(window.location.hostname) !== -1 && 
            !link.getAttribute('target') &&
            !link.getAttribute('download') &&
            !link.href.startsWith('mailto:') &&
            !link.href.startsWith('tel:') &&
            !link.href.startsWith('#')) {
              
          // Prevent default only for blog/pagination links
          e.preventDefault();
          
          // Get the href
          const href = link.getAttribute('href');
          
          // Show transition overlay
          const overlay = document.querySelector('.page-transition-overlay');
          if (overlay) {
            overlay.classList.add('active');
          }
          
          // Navigate after transition
          setTimeout(function() {
            window.location.href = href;
          }, 300);
        }
      });
    });
  }

  // Remove duplicate elements and clean DOM
  function cleanupDOM() {
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
      'nav:not(#main-nav)',
      '.content-wrapper .content-wrapper'
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
  
  // Organize containers for proper layout
  function organizeContainers() {
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
  
  // Optimize content wrapper nesting
  function optimizeContentWrappers() {
    // Handle multiple nested content-wrapper divs
    const nestedWrappers = document.querySelectorAll('.content-wrapper .content-wrapper');
    nestedWrappers.forEach(function(nestedWrapper) {
      // Get all child nodes
      const childNodes = Array.from(nestedWrapper.childNodes);
      
      // Get parent wrapper
      const parentWrapper = nestedWrapper.parentNode;
      
      // Move all children to parent and remove nested wrapper
      childNodes.forEach(function(node) {
        parentWrapper.insertBefore(node, nestedWrapper);
      });
      
      // Remove the now-empty nested wrapper
      if (nestedWrapper.parentNode) {
        nestedWrapper.parentNode.removeChild(nestedWrapper);
      }
    });
    
    // Consolidate content-wrapper divs that might have ended up with the same parent
    const firstLevelWrappers = document.querySelectorAll('.content-wrapper');
    firstLevelWrappers.forEach(function(wrapper, index) {
      if (index > 0) {
        const prevWrapper = firstLevelWrappers[index - 1];
        if (wrapper.parentNode === prevWrapper.parentNode) {
          // Move children of this wrapper to the first wrapper
          const childNodes = Array.from(wrapper.childNodes);
          childNodes.forEach(function(node) {
            prevWrapper.appendChild(node);
          });
          
          // Remove this wrapper
          if (wrapper.parentNode) {
            wrapper.parentNode.removeChild(wrapper);
          }
        }
      }
    });
  }
  
  // Set active navigation links
  function setActiveNavLinks() {
    const currentPath = document.body.getAttribute('data-path') || window.location.pathname;
    const currentHash = window.location.hash;
    
    if (!currentPath) return;
    
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(function(link) {
      const linkPath = link.getAttribute('data-path') || link.getAttribute('href');
      if (!linkPath) return;
      
      // Extract path and hash from link
      const linkParts = linkPath.split('#');
      const linkPathPart = linkParts[0];
      const linkHashPart = linkParts.length > 1 ? linkParts[1] : '';
      
      // Exact match for home
      if ((linkPathPart === '/' || linkPathPart === '') && (currentPath === '/' || currentPath === '/index.html')) {
        // For anchored links on home page
        if (linkHashPart && currentHash === '#' + linkHashPart) {
          link.classList.add('active');
        } 
        // For home link with no hash
        else if (!linkHashPart && !currentHash && (linkPathPart === '/' || linkPathPart === '')) {
          link.classList.add('active');
        }
      }
      // Match for other pages (including sub-pages)
      else if (linkPathPart !== '/' && currentPath && currentPath.startsWith(linkPathPart)) {
        link.classList.add('active');
      }
      // Special case for blog posts
      else if (linkPathPart === '/blog/' && currentPath && currentPath.includes('/20')) {
        link.classList.add('active');
      }
    });
  }
  
  // Optimize blog grid layout
  function optimizeBlogGrid() {
    const blogGrid = document.querySelector('.blog.grid');
    if (!blogGrid) return;
    
    // Apply grid-specific styling
    blogGrid.classList.add('grid-optimized');
    
    // Ensure proper display for the row and isotope elements inside
    const rowsAndIsotope = blogGrid.querySelectorAll('.row, .isotope');
    rowsAndIsotope.forEach(function(element) {
      element.style.display = 'contents';
      element.style.width = '100%';
    });
    
    // Optimize grid items
    const items = blogGrid.querySelectorAll('.item, .post');
    items.forEach(function(item) {
      item.style.width = '100%';
      item.style.position = 'static';
      item.style.left = 'auto';
      item.style.top = 'auto';
    });
  }
  
  // Enhance post styling
  function enhancePostStyling() {
    // Process all posts
    const posts = document.querySelectorAll('.post');
    posts.forEach(function(post) {
      // Add enhanced styling
      post.classList.add('post-enhanced');
      
      // Process post content padding
      const postContent = post.querySelector('.post-content');
      if (postContent) {
        postContent.classList.add('post-content-enhanced');
      }
      
      // Process post images
      const postFigure = post.querySelector('figure');
      if (postFigure) {
        postFigure.classList.add('post-figure-enhanced');
      }
    });
  }
  
  // Enhance sidebar styling
  function enhanceSidebarStyling() {
    const sidebar = document.querySelector('.sidebar');
    if (!sidebar) return;
    
    sidebar.classList.add('sidebar-enhanced');
    
    // Process sidebar widgets
    const widgets = sidebar.querySelectorAll('.widget');
    widgets.forEach(function(widget) {
      widget.classList.add('widget-enhanced');
    });
  }
  
  // Set body class based on current page
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
  
  // Optimize homepage layout
  function optimizeHomePageLayout() {
    // Check if we're on the home page
    if (window.location.pathname === '/' || window.location.pathname === '/index.html') {
      // Optimize hero section proportions
      const heroSection = document.querySelector('#home');
      if (heroSection) {
        heroSection.style.marginTop = '0';
        heroSection.style.paddingTop = '60px';
      }
      
      // Optimize services section spacing
      const servicesSection = document.querySelector('#services');
      if (servicesSection) {
        servicesSection.style.marginTop = '40px';
      }
      
      // Process nested content-wrapper divs
      const contentWrappers = document.querySelectorAll('.content-wrapper');
      if (contentWrappers.length > 1) {
        // Keep only the outermost content-wrapper
        contentWrappers.forEach(function(wrapper, index) {
          if (index > 0 && wrapper.parentElement && wrapper.parentElement.classList.contains('content-wrapper')) {
            // This is a nested content-wrapper, move its children up and remove it
            const parent = wrapper.parentElement;
            while (wrapper.firstChild) {
              parent.insertBefore(wrapper.firstChild, wrapper);
            }
            wrapper.remove();
          }
        });
      }
    }
  }
  
  // Initialize testimonials section
  function initTestimonials() {
    const testimonialSection = document.querySelector('#testimonials');
    if (!testimonialSection) return;
    
    // Fix testimonial blockquotes
    const blockquotes = testimonialSection.querySelectorAll('blockquote');
    blockquotes.forEach(function(blockquote) {
      // Ensure proper styling for blockquotes
      blockquote.classList.add('testimonial-quote');
      
      // Fix paragraphs inside blockquotes
      const paragraphs = blockquote.querySelectorAll('p');
      paragraphs.forEach(function(p) {
        // Remove any unnecessary line breaks or white space
        p.innerHTML = p.innerHTML.replace(/\s+/g, ' ').trim();
        
        // Wrap the text content in a div for controlled expansion
        const textWrapper = document.createElement('div');
        textWrapper.className = 'testimonial-text collapsed';
        textWrapper.innerHTML = p.innerHTML;
        p.innerHTML = '';
        p.appendChild(textWrapper);
        
        // Add read more button
        const readMoreBtn = document.createElement('button');
        readMoreBtn.className = 'read-more-btn';
        readMoreBtn.onclick = function() {
          textWrapper.classList.toggle('collapsed');
          textWrapper.classList.toggle('expanded');
          readMoreBtn.classList.toggle('expanded');
        };
        p.appendChild(readMoreBtn);
      });
      
      // Fix details section
      const details = blockquote.querySelector('.blockquote-details');
      if (details) {
        details.style.display = 'flex';
        details.style.alignItems = 'center';
        details.style.justifyContent = 'flex-start';
      }
      
      // Fix image blobs - make them simple circles
      const imgBlob = blockquote.querySelector('.img-blob');
      if (imgBlob) {
        imgBlob.classList.remove('blob1');
        imgBlob.style.width = '70px';
        imgBlob.style.height = '70px';
        imgBlob.style.overflow = 'hidden';
        imgBlob.style.borderRadius = '50%';
        imgBlob.style.border = '3px solid rgba(255, 255, 255, 0.3)';
        imgBlob.style.position = 'relative';
        imgBlob.style.display = 'block';
        
        // Fix image size inside blob
        const img = imgBlob.querySelector('img');
        if (img) {
          img.style.width = '100%';
          img.style.height = '100%';
          img.style.objectFit = 'cover';
          img.style.borderRadius = '50%';
          img.style.display = 'block';
        }
      }
    });
  }
  
  // Initialize all enhancements
  function initEnhancements() {
    cleanupDOM();
    organizeContainers();
    setActiveNavLinks();
    optimizeBlogGrid();
    enhancePostStyling();
    enhanceSidebarStyling();
    setBodyClass();
    optimizeHomePageLayout();
    
    // Set up mutation observer to continuously clean the DOM
    const observer = new MutationObserver(function() {
      cleanupDOM();
    });
    
    observer.observe(document.body, { 
      childList: true,
      subtree: true
    });
  }
  
  // Run all enhancements
  initEnhancements();
});

/**
 * Handle navigation functionality
 */
function initNavigation() {
  // Set active navigation links based on current URL
  const currentPath = window.location.pathname;
  const navLinks = document.querySelectorAll('.nav-link');
  
  // Add data-path attributes to navigation links if missing
  navLinks.forEach(function(link) {
    if (!link.getAttribute('data-path')) {
      link.setAttribute('data-path', link.getAttribute('href'));
    }
    
    const linkPath = link.getAttribute('data-path');
    
    // Handle active states
    if (linkPath === '/' && (currentPath === '/' || currentPath === '/index.html')) {
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
  
  // Handle header transparency on scroll for homepage
  if (currentPath === '/' || currentPath === '/index.html') {
    const header = document.getElementById('header');
    if (header) {
      window.addEventListener('scroll', function() {
        if (window.scrollY > 100) {
          header.classList.add('scrolled');
        } else {
          header.classList.remove('scrolled');
        }
        
        // Update active nav link based on scroll position
        updateActiveNavOnScroll();
      });
    }
    
    // Function to update active nav link based on current scroll position
    function updateActiveNavOnScroll() {
      // Get all sections with IDs that match nav links
      const sections = ['home', 'services', 'about', 'testimonials', 'contact'];
      const navLinks = document.querySelectorAll('.nav-link');
      
      // Determine which section is currently in view
      let currentSection = '';
      const scrollPosition = window.scrollY + 100; // Adding offset for header
      
      sections.forEach(function(sectionId) {
        const section = document.getElementById(sectionId);
        if (section) {
          const sectionTop = section.offsetTop;
          const sectionHeight = section.offsetHeight;
          
          if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
            currentSection = sectionId;
          }
        }
      });
      
      // Update active class on nav links
      if (currentSection) {
        navLinks.forEach(function(navLink) {
          const href = navLink.getAttribute('href');
          
          // Remove active class from all links
          navLink.classList.remove('active');
          
          // Add active class to matching link
          if (href === '/' && currentSection === 'home') {
            navLink.classList.add('active');
          } else if (href && href.endsWith('#' + currentSection)) {
            navLink.classList.add('active');
          }
        });
      }
    }
  }
  
  // Enhance hero section/images
  if (currentPath === '/' || currentPath === '/index.html') {
    const heroImage = document.querySelector('#home img');
    if (heroImage) {
      heroImage.style.maxHeight = '70vh';
      heroImage.style.borderRadius = '10px';
      heroImage.style.boxShadow = '0 10px 30px rgba(0,0,0,0.3)';
    }
  }
  
  // Handle mobile navigation toggle
  const toggleButtons = document.querySelectorAll('.navbar-toggler');
  toggleButtons.forEach(function(button) {
    button.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      const target = this.closest('.navbar').querySelector('.navbar-collapse');
      if (target) {
        if (target.classList.contains('show')) {
          target.classList.remove('show');
          target.style.height = '0';
        } else {
          target.classList.add('show');
          target.style.height = 'auto';
        }
      }
    });
  });
  
  // Close mobile menu when clicking outside
  document.addEventListener('click', function(event) {
    const navbarCollapse = document.querySelector('.navbar-collapse.show');
    if (navbarCollapse && !event.target.closest('.navbar')) {
      navbarCollapse.classList.remove('show');
      navbarCollapse.style.height = '0';
    }
  });
  
  // Close mobile menu when clicking a link
  navLinks.forEach(function(link) {
    link.addEventListener('click', function() {
      const navbarCollapse = document.querySelector('.navbar-collapse.show');
      if (navbarCollapse) {
        navbarCollapse.classList.remove('show');
        navbarCollapse.style.height = '0';
      }
      
      // If this is an anchor link to a section on the same page
      const href = link.getAttribute('href');
      if (href && href.includes('#') && (href.startsWith('#') || href.startsWith('/#'))) {
        // Highlight this link as active
        navLinks.forEach(navLink => navLink.classList.remove('active'));
        link.classList.add('active');
      }
    });
  });
  
  // Remove duplicate navigation systems
  setTimeout(function() {
    const duplicateNavs = document.querySelectorAll('.navbar:not(:first-of-type)');
    duplicateNavs.forEach(function(nav) {
      if (nav.parentElement && nav.parentElement !== document.getElementById('header')) {
        nav.parentElement.remove();
      }
    });
  }, 100);
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
        
        // Ensure pre has relative positioning for proper label placement
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
    
    // Ensure pre has relative positioning for proper button placement
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
  // Handle all anchor links
  document.querySelectorAll('a[href*="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
      // Get the target hash from the href
      const hrefParts = this.getAttribute('href').split('#');
      if (hrefParts.length < 2) return; // No hash part
      
      const targetId = hrefParts[1];
      if (!targetId) return; // Empty hash
      
      // Check if we need to navigate to a different page first
      const pathPart = hrefParts[0];
      const currentPath = window.location.pathname;
      
      // If we're already on the correct page, or it's an anchor on the same page
      if (pathPart === '' || pathPart === '/' && (currentPath === '/' || currentPath === '/index.html')) {
        const targetElement = document.getElementById(targetId);
        if (!targetElement) return;
        
        e.preventDefault();
        
        window.scrollTo({
          top: targetElement.offsetTop - 80, // Account for header height
          behavior: 'smooth'
        });
        
        // Update URL without page jump
        history.pushState(null, null, '#' + targetId);
      }
    });
  });
}

/**
 * Initialize Owl Carousel for the "You Might Also Like" section
 */
function initOwlCarousel() {
  // Only init if there's actually a carousel on the page
  if (!document.querySelector('.owl-carousel')) {
    return;
  }

  if (typeof $ === 'undefined' || typeof $.fn === 'undefined' || typeof $.fn.owlCarousel === 'undefined') {
    // Load jQuery if not available
    if (typeof $ === 'undefined') {
      const script = document.createElement('script');
      script.src = 'https://code.jquery.com/jquery-3.6.0.min.js';
      script.onload = function() {
        loadOwlCarousel();
      };
      document.head.appendChild(script);
    } else {
      loadOwlCarousel();
    }
    return;
  }

  $('.owl-carousel').each(function() {
    const $carousel = $(this);
    
    // Get data attributes
    const margin = $carousel.data('margin') || 30;
    const dots = $carousel.data('dots') !== undefined ? $carousel.data('dots') : true;
    const autoplay = $carousel.data('autoplay') !== undefined ? $carousel.data('autoplay') : false;
    const autoplayTimeout = $carousel.data('autoplay-timeout') || 5000;
    
    // Special settings for testimonials section
    const isTestimonial = $carousel.closest('#testimonials').length > 0;
    
    const responsive = $carousel.data('responsive') || {
      "0": { "items": 1 },
      "768": { "items": isTestimonial ? 2 : 2 },
      "992": { "items": isTestimonial ? 3 : 3 }
    };
    
    // Initialize carousel with specific settings for testimonials
    $carousel.owlCarousel({
      margin: isTestimonial ? 20 : margin,
      nav: true,
      navText: ['<i class="jam jam-arrow-left"></i>', '<i class="jam jam-arrow-right"></i>'],
      dots: true,
      autoplay: isTestimonial ? true : autoplay,
      autoplayTimeout: isTestimonial ? 7000 : autoplayTimeout,
      responsive: isTestimonial ? {
        "0": { "items": 1 },
        "768": { "items": 2 },
        "992": { "items": 3 }
      } : responsive,
      loop: true,
      rewind: true,
      autoHeight: false,
      items: isTestimonial ? 3 : 3,
      stagePadding: isTestimonial ? 20 : 0,
      onInitialized: function(event) {
        if (isTestimonial) {
          // Force visibility for Nav buttons and profile images
          setTimeout(function() {
            $carousel.find('.owl-nav').css('display', 'flex');
            $carousel.find('.owl-nav button').css('opacity', '1');
            $carousel.find('.img-blob').css('opacity', '1');
            $carousel.find('.img-blob img').css('opacity', '1');
            equalizeTestimonialHeight(event);
          }, 100);
        } else {
          equalizeCarouselHeight(event);
        }
      },
      onResized: function(event) {
        if (isTestimonial) {
          setTimeout(function() {
            equalizeTestimonialHeight(event);
          }, 100);
        } else {
          equalizeCarouselHeight(event);
        }
      },
      onTranslated: function(event) {
        if (isTestimonial) {
          setTimeout(function() {
            equalizeTestimonialHeight(event);
          }, 100);
        } else {
          equalizeCarouselHeight(event);
        }
      }
    });
    
    // Special function for testimonial height equalization
    function equalizeTestimonialHeight(event) {
      const items = $carousel.find('.owl-item');
      items.height('auto');
      
      // Reset blockquote heights
      items.find('blockquote').css('height', 'auto');
      
      // Separately calculate max height for blockquotes, avoiding full height item setting
      let maxBlockquoteHeight = 0;
      items.each(function() {
        const blockquote = $(this).find('blockquote');
        const height = blockquote.outerHeight();
        maxBlockquoteHeight = Math.max(maxBlockquoteHeight, height);
      });
      
      // Set equal height to all blockquotes, not the entire item
      if (maxBlockquoteHeight > 0) {
        items.find('blockquote').height(maxBlockquoteHeight);
      }
    }

    // Standard equalizer for other carousels
    function equalizeCarouselHeight(event) {
      setTimeout(function() {
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
          $carousel.find('.owl-stage').height(maxHeight);
        }
      }, 100);
    }
  });
}

/**
 * Load Owl Carousel script if not already loaded
 */
function loadOwlCarousel() {
  if (typeof $.fn.owlCarousel === 'undefined') {
    // First load font awesome for navigation arrows
    const fontAwesome = document.createElement('link');
    fontAwesome.rel = 'stylesheet';
    fontAwesome.href = 'https://cdn.jsdelivr.net/npm/jam-icons@2.0.0/css/jam-icons.min.css';
    document.head.appendChild(fontAwesome);
    
    // Then load Owl Carousel scripts and styles
    const script = document.createElement('script');
    script.src = 'https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js';
    script.onload = function() {
      initOwlCarousel();
    };
    document.head.appendChild(script);
    
    // Also load the CSS
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css';
    document.head.appendChild(link);
    
    const linkTheme = document.createElement('link');
    linkTheme.rel = 'stylesheet';
    linkTheme.href = 'https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css';
    document.head.appendChild(linkTheme);
  }
} 