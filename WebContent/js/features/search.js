// Search Feature JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {
    // Initialize elements
    const searchInput = document.getElementById('searchInput');
    const searchButton = document.getElementById('searchButton');
    const categoryFilter = document.getElementById('categoryFilter');
    const sortFilter = document.getElementById('sortFilter');
    const prevPageButton = document.getElementById('prevPage');
    const nextPageButton = document.getElementById('nextPage');
    const pageInfo = document.getElementById('pageInfo');
    const resultCount = document.getElementById('resultCount');
    const searchResults = document.getElementById('searchResults');

    // State management
    let currentPage = 1;
    let totalPages = 1;
    let currentResults = [];
    let searchQuery = '';
    let selectedCategory = '';
    let sortBy = 'name';

    // Add event listeners
    searchButton.addEventListener('click', performSearch);
    searchInput.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            performSearch();
        }
    });
    categoryFilter.addEventListener('change', function() {
        selectedCategory = this.value;
        performSearch();
    });
    sortFilter.addEventListener('change', function() {
        sortBy = this.value;
        performSearch();
    });
    prevPageButton.addEventListener('click', () => changePage(currentPage - 1));
    nextPageButton.addEventListener('click', () => changePage(currentPage + 1));

    // Initialize search
    performSearch();
});

// Perform search operation
async function performSearch() {
    const searchInput = document.getElementById('searchInput');
    const searchResults = document.getElementById('searchResults');
    
    searchQuery = searchInput.value.trim();
    currentPage = 1; // Reset to first page

    // Show loading state
    searchResults.innerHTML = '<div class="loading"></div>';

    try {
        const response = await fetch('/api/search', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                query: searchQuery,
                category: selectedCategory,
                sortBy: sortBy,
                page: currentPage,
                pageSize: 12
            })
        });

        if (response.ok) {
            const data = await response.json();
            updateSearchResults(data);
        } else {
            throw new Error('Search failed');
        }
    } catch (error) {
        showErrorMessage(error.message);
        searchResults.innerHTML = '<p class="error">Failed to load search results</p>';
    }
}

// Update search results display
function updateSearchResults(data) {
    const searchResults = document.getElementById('searchResults');
    const resultCount = document.getElementById('resultCount');
    const pageInfo = document.getElementById('pageInfo');
    const prevPageButton = document.getElementById('prevPage');
    const nextPageButton = document.getElementById('nextPage');

    // Update result count
    resultCount.textContent = `${data.total} items found`;

    // Update pagination
    currentPage = data.currentPage;
    totalPages = data.totalPages;
    pageInfo.textContent = `Page ${currentPage} of ${totalPages}`;
    prevPageButton.disabled = currentPage === 1;
    nextPageButton.disabled = currentPage === totalPages;

    // Clear previous results
    searchResults.innerHTML = '';

    // Display new results
    data.results.forEach(item => {
        const resultCard = createResultCard(item);
        searchResults.appendChild(resultCard);
    });

    // Show no results message if needed
    if (data.results.length === 0) {
        searchResults.innerHTML = '<p class="no-results">No results found</p>';
    }
}

// Create result card element
function createResultCard(item) {
    const card = document.createElement('div');
    card.className = 'result-card';
    card.innerHTML = `
        <h3>${item.name}</h3>
        <p>${item.description}</p>
        <div class="amount">₱${item.amount.toFixed(2)}</div>
        <span class="category">${item.category}</span>
    `;
    return card;
}

// Change page
async function changePage(newPage) {
    if (newPage < 1 || newPage > totalPages) return;
    
    currentPage = newPage;
    await performSearch();
}

// Show error message
function showErrorMessage(message) {
    // TODO: Implement proper error message display
    alert('Error: ' + message);
}

// Update user information
function updateUserInfo(user) {
    const userInfo = document.getElementById('currentUser');
    if (user) {
        userInfo.textContent = `Welcome, ${user.name}`;
    } else {
        userInfo.textContent = 'Welcome, Guest';
    }
} 