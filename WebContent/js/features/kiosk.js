// KIOSK JavaScript functionality
document.addEventListener('DOMContentLoaded', function() {
    // Initialize payment cards
    const paymentCards = document.querySelectorAll('.payment-card');
    const paymentDetails = document.querySelector('.payment-details');
    const paymentForm = document.getElementById('paymentForm');

    // Add click event listeners to payment cards
    paymentCards.forEach(card => {
        card.addEventListener('click', function() {
            const paymentType = this.dataset.type;
            showPaymentDetails(paymentType);
        });
    });

    // Handle payment form submission
    paymentForm.addEventListener('submit', function(e) {
        e.preventDefault();
        processPayment();
    });
});

// Show payment details form
function showPaymentDetails(paymentType) {
    const paymentDetails = document.querySelector('.payment-details');
    const paymentOptions = document.querySelector('.payment-options');
    
    // Hide payment options and show payment details
    paymentOptions.style.display = 'none';
    paymentDetails.style.display = 'block';
    
    // Update form with payment type
    const form = document.getElementById('paymentForm');
    form.dataset.paymentType = paymentType;
}

// Cancel payment and return to payment options
function cancelPayment() {
    const paymentDetails = document.querySelector('.payment-details');
    const paymentOptions = document.querySelector('.payment-options');
    
    // Show payment options and hide payment details
    paymentOptions.style.display = 'block';
    paymentDetails.style.display = 'none';
    
    // Reset form
    document.getElementById('paymentForm').reset();
}

// Process payment
async function processPayment() {
    const form = document.getElementById('paymentForm');
    const formData = new FormData(form);
    const paymentData = {
        type: form.dataset.paymentType,
        amount: formData.get('amount'),
        reference: formData.get('reference'),
        description: formData.get('description')
    };

    try {
        // TODO: Implement API call to process payment
        const response = await fetch('/api/payment/process', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(paymentData)
        });

        if (response.ok) {
            const result = await response.json();
            showSuccessMessage(result);
        } else {
            throw new Error('Payment processing failed');
        }
    } catch (error) {
        showErrorMessage(error.message);
    }
}

// Show success message
function showSuccessMessage(result) {
    // TODO: Implement success message display
    alert('Payment processed successfully!');
    window.location.href = '../jsp/features/priority.jsp'; // Redirect to priority number page
}

// Show error message
function showErrorMessage(message) {
    // TODO: Implement error message display
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