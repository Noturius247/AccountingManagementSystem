// Student verification and autofill functionality
function initStudentVerification(options = {}) {
    const studentIdField = document.getElementById('studentId');
    const studentInfo = document.getElementById('studentInfo');
    
    // Get context path and CSRF token from the page
    const metaTag = document.querySelector('meta[name="context-path"]');
    const contextPath = metaTag ? metaTag.getAttribute('content') : '';
    
    // Get CSRF token if available
    const csrfToken = document.querySelector('meta[name="_csrf"]')?.getAttribute('content');
    const csrfHeader = document.querySelector('meta[name="_csrf_header"]')?.getAttribute('content');
    
    // Fields to autofill
    const fields = {
        academicYear: options.academicYear !== false,
        semester: options.semester !== false,
        program: options.program !== false,
        section: options.section !== false,
        yearLevel: options.yearLevel !== false
    };
    
    studentIdField.addEventListener('blur', function() {
        const studentId = this.value.trim();
        
        if (studentId) {
            // Show loading indicator
            if (studentInfo) {
                studentInfo.innerHTML = '<div class="loading">Verifying student...</div>';
                studentInfo.style.display = 'block';
            }
            
            // Prepare headers
            const headers = {
                'Content-Type': 'application/x-www-form-urlencoded',
            };
            
            // Add CSRF token if available
            if (csrfToken && csrfHeader) {
                headers[csrfHeader] = csrfToken;
            }
            
            // Make the request
            fetch(contextPath + '/kiosk/verify-student?studentId=' + encodeURIComponent(studentId), {
                method: 'GET',
                headers: headers
            })
            .then(response => {
                if (!response.ok) {
                    return response.json().then(err => Promise.reject(err));
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                
                // Display student info
                if (studentInfo) {
                    studentInfo.innerHTML = `
                        <div class="info-text success">
                            <strong>Student Name:</strong> ${data.fullName}<br>
                            <strong>Program:</strong> ${data.program}<br>
                            <strong>Year Level:</strong> ${data.yearLevel}<br>
                            <strong>Section:</strong> ${data.section || 'N/A'}
                        </div>
                    `;
                    studentInfo.style.display = 'block';
                }
                
                // Autofill fields if they exist
                if (fields.program) {
                    const programField = document.getElementById('program');
                    if (programField) {
                        programField.value = data.program || '';
                        programField.readOnly = true;
                    }
                }

                if (fields.yearLevel) {
                    const yearLevelField = document.getElementById('yearLevel');
                    if (yearLevelField) {
                        yearLevelField.value = data.yearLevel || '';
                        yearLevelField.readOnly = true;
                    }
                }

                if (fields.section) {
                    const sectionField = document.getElementById('section');
                    if (sectionField) {
                        sectionField.value = data.section || '';
                        sectionField.readOnly = true;
                    }
                }

                if (fields.academicYear) {
                    const academicYearField = document.getElementById('academicYear');
                    if (academicYearField) {
                        academicYearField.value = data.academicYear || '';
                        academicYearField.readOnly = true;
                    }
                }

                if (fields.semester) {
                    const semesterField = document.getElementById('semester');
                    if (semesterField) {
                        semesterField.value = data.semester || '';
                        semesterField.readOnly = true;
                    }
                }
                
                // Trigger any custom callback
                if (options.onVerificationSuccess) {
                    options.onVerificationSuccess(data);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                if (studentInfo) {
                    studentInfo.innerHTML = `
                        <div class="error-message">
                            ${error.message || 'Error verifying student. Please try again.'}
                        </div>
                    `;
                    studentInfo.style.display = 'block';
                }
                resetFields();
            });
        } else {
            if (studentInfo) {
                studentInfo.style.display = 'none';
            }
            resetFields();
        }
    });
    
    function resetFields() {
        const fields = {
            program: document.getElementById('program'),
            yearLevel: document.getElementById('yearLevel'),
            section: document.getElementById('section'),
            academicYear: document.getElementById('academicYear'),
            semester: document.getElementById('semester')
        };
        
        Object.values(fields).forEach(field => {
            if (field) {
                field.value = '';
                field.readOnly = false;
            }
        });
        
        if (options.onReset) {
            options.onReset();
        }
    }
} 