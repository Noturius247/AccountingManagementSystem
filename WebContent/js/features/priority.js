// Priority Number Generator JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {
    // Initialize elements
    const getNumberBtn = document.getElementById('getNumber');
    const checkStatusBtn = document.getElementById('checkStatus');
    const currentNumberDisplay = document.getElementById('currentNumber');
    const nextNumberDisplay = document.getElementById('nextNumber');
    const totalQueueDisplay = document.getElementById('totalQueue');
    const waitTimeDisplay = document.getElementById('waitTime');
    const numberHistory = document.getElementById('numberHistory');

    // Add event listeners
    getNumberBtn.addEventListener('click', getPriorityNumber);
    checkStatusBtn.addEventListener('click', checkQueueStatus);

    // Initialize WebSocket connection for real-time updates
    initializeWebSocket();
});

// Get a new priority number
async function getPriorityNumber() {
    try {
        const response = await fetch('/api/queue/get-number', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                userId: getCurrentUserId(),
                timestamp: new Date().toISOString()
            })
        });

        if (response.ok) {
            const result = await response.json();
            updateQueueDisplay(result);
            showSuccessMessage('Your priority number is: ' + result.number);
        } else {
            throw new Error('Failed to get priority number');
        }
    } catch (error) {
        showErrorMessage(error.message);
    }
}

// Check current queue status
async function checkQueueStatus() {
    try {
        const response = await fetch('/api/queue/status');
        if (response.ok) {
            const status = await response.json();
            updateQueueDisplay(status);
        } else {
            throw new Error('Failed to get queue status');
        }
    } catch (error) {
        showErrorMessage(error.message);
    }
}

// Update queue display with new information
function updateQueueDisplay(data) {
    const currentNumberDisplay = document.getElementById('currentNumber');
    const nextNumberDisplay = document.getElementById('nextNumber');
    const totalQueueDisplay = document.getElementById('totalQueue');
    const waitTimeDisplay = document.getElementById('waitTime');

    // Update current number
    if (data.currentNumber) {
        currentNumberDisplay.textContent = data.currentNumber;
        currentNumberDisplay.classList.add('updated');
        setTimeout(() => currentNumberDisplay.classList.remove('updated'), 500);
    }

    // Update next number
    if (data.nextNumber) {
        nextNumberDisplay.textContent = data.nextNumber;
        nextNumberDisplay.classList.add('updated');
        setTimeout(() => nextNumberDisplay.classList.remove('updated'), 500);
    }

    // Update queue statistics
    if (data.totalInQueue !== undefined) {
        totalQueueDisplay.textContent = data.totalInQueue;
    }
    if (data.estimatedWaitTime !== undefined) {
        waitTimeDisplay.textContent = data.estimatedWaitTime + ' mins';
    }

    // Update number history
    if (data.recentNumbers) {
        updateNumberHistory(data.recentNumbers);
    }
}

// Update the number history display
function updateNumberHistory(numbers) {
    const historyList = document.getElementById('numberHistory');
    historyList.innerHTML = '';
    
    numbers.forEach(number => {
        const historyItem = document.createElement('div');
        historyItem.className = 'history-item';
        historyItem.textContent = number;
        historyList.appendChild(historyItem);
    });
}

// Initialize WebSocket connection for real-time updates
function initializeWebSocket() {
    const ws = new WebSocket('ws://' + window.location.host + '/ws/queue');
    
    ws.onmessage = function(event) {
        const data = JSON.parse(event.data);
        updateQueueDisplay(data);
    };

    ws.onerror = function(error) {
        console.error('WebSocket error:', error);
    };

    ws.onclose = function() {
        console.log('WebSocket connection closed');
        // Attempt to reconnect after 5 seconds
        setTimeout(initializeWebSocket, 5000);
    };
}

// Show success message
function showSuccessMessage(message) {
    // TODO: Implement proper success message display
    alert(message);
}

// Show error message
function showErrorMessage(message) {
    // TODO: Implement proper error message display
    alert('Error: ' + message);
}

// Get current user ID (placeholder)
function getCurrentUserId() {
    // TODO: Implement proper user ID retrieval
    return 'user-' + Math.random().toString(36).substr(2, 9);
} 