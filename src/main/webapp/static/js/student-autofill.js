// Student Auto-fill Functionality
function initializeStudentAutofill(formId) {
    const form = document.getElementById(formId);
    const studentIdInput = form.querySelector('#studentId');
    const loadingSpinner = form.querySelector('.loading');
    const errorMessage = form.querySelector('.error-message');
    const studentInfo = form.querySelector('.student-info');
    const submitBtn = form.querySelector('.submit-btn');
    let typingTimer;
    const doneTypingInterval = 1000; // 1 second

    function showLoading(show) {
        if (loadingSpinner) {
            loadingSpinner.style.display = show ? 'inline-block' : 'none';
        }
    }

    function showError(message) {
        if (errorMessage) {
            errorMessage.textContent = message;
            errorMessage.style.display = message ? 'block' : 'none';
        }
        if (studentInfo) {
            studentInfo.style.display = 'none';
        }
        if (submitBtn) {
            submitBtn.disabled = true;
        }
    }

    function populateStudentInfo(data) {
        if (!studentInfo) return;

        // Update display info
        const nameSpan = studentInfo.querySelector('#studentName');
        const programSpan = studentInfo.querySelector('#program');
        const yearLevelSpan = studentInfo.querySelector('#yearLevel');
        const academicYearSpan = studentInfo.querySelector('#academicYear');
        const semesterSpan = studentInfo.querySelector('#semester');

        if (nameSpan) nameSpan.textContent = data.fullName || '';
        if (programSpan) programSpan.textContent = data.program || '';
        if (yearLevelSpan) yearLevelSpan.textContent = data.yearLevel || '';
        if (academicYearSpan) academicYearSpan.textContent = data.academicYear || '';
        if (semesterSpan) semesterSpan.textContent = data.semester || '';
        
        // Update form fields if they exist
        const programInput = form.querySelector('select[name="program"]');
        if (programInput && data.program) {
            const option = Array.from(programInput.options)
                .find(opt => opt.value === data.program || opt.textContent === data.program);
            if (option) programInput.value = option.value;
        }
        
        const yearLevelInput = form.querySelector('input[name="yearLevel"]');
        if (yearLevelInput) yearLevelInput.value = data.yearLevel || '';
        
        const academicYearInput = form.querySelector('select[name="academicYear"]');
        if (academicYearInput && data.academicYear) {
            const option = Array.from(academicYearInput.options)
                .find(opt => opt.value === data.academicYear || opt.textContent === data.academicYear);
            if (option) academicYearInput.value = option.value;
        }
        
        const semesterInput = form.querySelector('select[name="semester"]');
        if (semesterInput && data.semester) {
            const option = Array.from(semesterInput.options)
                .find(opt => opt.value === data.semester || opt.textContent.toUpperCase().includes(data.semester));
            if (option) semesterInput.value = option.value;
        }
        
        studentInfo.style.display = 'block';
        if (submitBtn) {
            submitBtn.disabled = false;
        }
    }

    function verifyStudent() {
        if (!studentIdInput) return;

        const studentId = studentIdInput.value.trim();
        if (!studentId) {
            showError('Please enter a Student ID');
            return;
        }

        showLoading(true);
        showError('');

        const verifyUrl = form.getAttribute('data-verify-url');
        if (!verifyUrl) {
            showError('Verification URL not configured');
            showLoading(false);
            return;
        }

        // Get CSRF token
        const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content') 
            || form.querySelector('input[name="_csrf"]')?.value;
        const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content') 
            || 'X-CSRF-TOKEN';

        const formData = new FormData();
        formData.append('studentId', studentId);
        if (csrfToken) {
            formData.append('_csrf', csrfToken);
        }

        fetch(verifyUrl, {
            method: 'POST',
            headers: {
                'Accept': 'application/json',
                ...(csrfToken && { [csrfHeader]: csrfToken })
            },
            body: formData,
            credentials: 'same-origin'
        })
        .then(response => {
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const contentType = response.headers.get('content-type');
            if (!contentType || !contentType.includes('application/json')) {
                throw new TypeError("Response was not JSON");
            }
            return response.json();
        })
        .then(data => {
            showLoading(false);
            if (data.success) {
                populateStudentInfo(data);
            } else {
                showError(data.error || 'Failed to verify student');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showLoading(false);
            if (error instanceof TypeError && error.message === "Response was not JSON") {
                showError('Session expired. Please refresh the page.');
            } else {
                showError('An error occurred while verifying student. Please try again.');
            }
        });
    }

    // Only set up event listeners if we have a student ID input
    if (studentIdInput) {
        studentIdInput.addEventListener('keyup', function(e) {
            clearTimeout(typingTimer);
            if (e.key === 'Enter') {
                e.preventDefault(); // Prevent form submission
                verifyStudent();
            } else {
                typingTimer = setTimeout(verifyStudent, doneTypingInterval);
            }
        });

        studentIdInput.addEventListener('keydown', function() {
            clearTimeout(typingTimer);
        });

        // Initial verification if student ID is pre-filled
        if (studentIdInput.value.trim()) {
            verifyStudent();
        }
    }

    // Form validation before submission
    form.addEventListener('submit', function(e) {
        const amount = form.querySelector('input[name="amount"]');
        if (amount && (!amount.value || parseFloat(amount.value) <= 0)) {
            e.preventDefault();
            alert('Please enter a valid amount greater than 0');
            return false;
        }
        // Ensure form submits to the correct URL
        const actionUrl = form.getAttribute('action');
        if (!actionUrl.endsWith('/process')) {
            form.setAttribute('action', actionUrl + '/process');
        }
        return true;
    });
} 