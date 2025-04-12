<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Payment Items</title>
    <link rel="stylesheet" href="../css/features/search.css">
</head>
<body>
    <div class="search-container">
        <header>
            <h1>Search Payment Items</h1>
            <div class="user-info">
                <span id="currentUser">Welcome, Guest</span>
            </div>
        </header>

        <main>
            <div class="search-section">
                <div class="search-box">
                    <input type="text" id="searchInput" placeholder="Search for payment items...">
                    <button id="searchButton" class="btn-primary">Search</button>
                </div>
                <div class="filter-options">
                    <select id="categoryFilter">
                        <option value="">All Categories</option>
                        <option value="tuition">Tuition Fee</option>
                        <option value="miscellaneous">Miscellaneous</option>
                        <option value="library">Library Fee</option>
                        <option value="laboratory">Laboratory Fee</option>
                    </select>
                    <select id="sortFilter">
                        <option value="name">Sort by Name</option>
                        <option value="amount">Sort by Amount</option>
                        <option value="category">Sort by Category</option>
                    </select>
                </div>
            </div>

            <div class="results-section">
                <div class="results-header">
                    <h2>Search Results</h2>
                    <span id="resultCount">0 items found</span>
                </div>
                <div class="results-grid" id="searchResults">
                    <!-- Results will be dynamically added here -->
                </div>
            </div>

            <div class="pagination">
                <button id="prevPage" class="btn-secondary" disabled>Previous</button>
                <span id="pageInfo">Page 1 of 1</span>
                <button id="nextPage" class="btn-secondary" disabled>Next</button>
            </div>
        </main>

        <footer>
            <p>Need help? <a href="../jsp/features/faq.jsp">View FAQs</a></p>
        </footer>
    </div>

    <script src="../js/features/search.js"></script>
</body>
</html> 