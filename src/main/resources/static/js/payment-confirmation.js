// Function to handle payment confirmation
function confirmPayment(transactionRef) {
    if (!transactionRef) {
        console.error('Transaction reference is missing');
        return;
    }

    // Show loading state
    const confirmButton = document.getElementById('confirmPaymentButton');
    if (confirmButton) {
        confirmButton.disabled = true;
        confirmButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    }

    // Get queue number if available
    const queueNumber = confirmButton ? confirmButton.getAttribute('data-queue-number') : null;

    fetch(`/kiosk/payment/confirm/${transactionRef}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        },
        body: JSON.stringify({
            queueNumber: queueNumber
        }),
        credentials: 'same-origin'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        if (data.success) {
            // Update button to show success state
            if (confirmButton) {
                confirmButton.innerHTML = '<i class="fas fa-check-circle"></i> Payment Successful';
                confirmButton.classList.remove('btn-confirm');
                confirmButton.classList.add('btn-success');
                confirmButton.disabled = true;
            }

            // Update status if it exists
            const statusElement = document.querySelector('.status-pending');
            if (statusElement) {
                statusElement.textContent = 'PAID';
                statusElement.classList.remove('status-pending');
                statusElement.style.color = '#28a745';
            }

            // Mark this transaction as confirmed
            sessionStorage.setItem('confirmed_' + transactionRef, 'true');

            // Create or update queue number display
            let queueDisplayContainer = document.querySelector('.queue-display-container');
            if (!queueDisplayContainer) {
                queueDisplayContainer = document.createElement('div');
                queueDisplayContainer.className = 'queue-display-container';
                confirmButton.parentElement.insertAdjacentElement('afterend', queueDisplayContainer);
            }

            // Show queue information
            let message = 'Your payment has been processed successfully!';
            if (data.queueNumber || queueNumber) {
                const displayQueueNumber = data.queueNumber || queueNumber;
                
                // Update queue display container
                queueDisplayContainer.innerHTML = `
                    <div class="card">
                        <div class="card-body">
                            <h3 class="text-primary mb-3">Your Queue Information</h3>
                            <div class="queue-number-display">
                                <h1 class="display-4 text-center text-primary mb-3">${displayQueueNumber}</h1>
                            </div>
                            <div class="queue-details">
                                ${data.position ? `<p class="mb-2">Position in Queue: <strong>${data.position}</strong></p>` : ''}
                                ${data.estimatedWaitTime ? `<p class="mb-2">Estimated Wait Time: <strong>${data.estimatedWaitTime} minutes</strong></p>` : ''}
                            </div>
                        </div>
                    </div>
                `;

                // Add visible class after a short delay for animation
                setTimeout(() => {
                    queueDisplayContainer.classList.add('visible');
                }, 100);

                message += `<br><br>Your Queue Number: <strong>${displayQueueNumber}</strong>`;
                if (data.position) {
                    message += `<br>Position in Queue: <strong>${data.position}</strong>`;
                }
                if (data.estimatedWaitTime) {
                    message += `<br>Estimated Wait Time: <strong>${data.estimatedWaitTime} minutes</strong>`;
                }
            }

            Swal.fire({
                title: 'Payment Successful!',
                html: message,
                icon: 'success',
                confirmButtonText: 'OK'
            }).then((result) => {
                if (result.isConfirmed && (data.queueNumber || queueNumber)) {
                    // Show loading message before redirect
                    Swal.fire({
                        title: 'Redirecting...',
                        html: 'Please wait while we redirect you to the queue status page.',
                        timer: 2000,
                        timerProgressBar: true,
                        showConfirmButton: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    }).then(() => {
                        // Redirect to queue status page
                        window.location.href = `/kiosk/queue/status?number=${data.queueNumber || queueNumber}`;
                    });
                }
            });
        } else {
            // Reset button state
            if (confirmButton) {
                confirmButton.disabled = false;
                confirmButton.innerHTML = '<i class="fas fa-receipt"></i> Review Payment';
            }

            // Show error message
            Swal.fire({
                title: 'Payment Error',
                text: data.message || 'Failed to process payment. Please try again.',
                icon: 'error',
                confirmButtonText: 'OK'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        
        // Reset button state
        if (confirmButton) {
            confirmButton.disabled = false;
            confirmButton.innerHTML = '<i class="fas fa-receipt"></i> Review Payment';
        }

        // Show error message
        Swal.fire({
            title: 'Error',
            text: 'An error occurred while processing your payment. Please try again.',
            icon: 'error',
            confirmButtonText: 'OK'
        });
    });
} 