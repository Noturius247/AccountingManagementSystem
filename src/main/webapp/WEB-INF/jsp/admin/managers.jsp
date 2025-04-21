<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="content-wrapper">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0">Manager Management</h1>
                </div>
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn btn-primary" id="addManagerBtn">
                            <i class="bi bi-plus-circle"></i> Add New Manager
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="content">
        <div class="container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group mb-0">
                                <input type="text" class="form-control" id="managerSearch" placeholder="Search managers...">
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <select class="form-control" id="departmentFilter">
                                    <option value="">All Departments</option>
                                    <c:forEach items="${departments}" var="dept">
                                        <option value="${dept}">${dept}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="form-group mb-0">
                                <select class="form-control" id="statusFilter">
                                    <option value="">All Status</option>
                                    <option value="ACTIVE">Active</option>
                                    <option value="INACTIVE">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Department</th>
                                    <th>Status</th>
                                    <th>Assigned Students</th>
                                    <th>Last Active</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody id="managerTableBody">
                                <c:forEach items="${managers}" var="manager">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <img src="<c:url value='${not empty manager.profileImage ? manager.profileImage : "/static/img/default-avatar.png"}'/>" 
                                                     class="rounded-circle mr-2" width="40" height="40" alt="${manager.name}">
                                                <div>
                                                    <div class="font-weight-bold"><c:out value="${manager.name}"/></div>
                                                    <small class="text-muted"><c:out value="${manager.employeeId}"/></small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>${manager.email}</td>
                                        <td>${manager.department}</td>
                                        <td>
                                            <span class="badge ${manager.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'}">
                                                ${manager.status}
                                            </span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <span class="mr-2">${manager.assignedStudentsCount}</span>
                                                <button class="btn btn-sm btn-outline-primary view-students-btn" 
                                                        data-manager-id="${manager.id}" title="View Students">
                                                    View
                                                </button>
                                            </div>
                                        </td>
                                        <td>${manager.lastActiveAt}</td>
                                        <td>
                                            <div class="btn-group">
                                                <button class="btn btn-sm btn-info edit-manager-btn" 
                                                        data-manager-id="${manager.id}" title="Edit">
                                                    <i class="bi bi-pencil"></i>
                                                </button>
                                                <button class="btn btn-sm btn-primary assign-students-btn" 
                                                        data-manager-id="${manager.id}" title="Assign Students">
                                                    <i class="bi bi-people"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger delete-manager-btn" 
                                                        data-manager-id="${manager.id}" title="Delete">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="d-flex justify-content-between align-items-center">
                        <div class="text-muted">
                            Showing <span id="startCount">1</span> to <span id="endCount">10</span> of <span id="totalCount">${totalManagers}</span> entries
                        </div>
                        <div class="pagination">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <button class="btn btn-outline-primary mr-2" data-page="${currentPage - 1}">Previous</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-outline-primary mr-2" disabled>Previous</button>
                                </c:otherwise>
                            </c:choose>
                            
                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                <button class="btn ${pageNum eq currentPage ? 'btn-primary' : 'btn-outline-primary'} mr-2" 
                                        data-page="${pageNum}"><c:out value="${pageNum}"/></button>
                            </c:forEach>
                            
                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <button class="btn btn-outline-primary" data-page="${currentPage + 1}">Next</button>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn btn-outline-primary" disabled>Next</button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Toast Container -->
<div class="toast-container position-fixed top-0 end-0 p-3" style="z-index: 1050;">
    <div id="notificationToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-delay="3000">
        <div class="toast-header">
            <strong class="mr-auto" id="toastTitle"></strong>
            <button type="button" class="ml-2 mb-1 close" data-dismiss="toast">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="toast-body" id="toastMessage"></div>
    </div>
</div>

<!-- Add/Edit Manager Modal -->
<div class="modal fade" id="managerModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="managerModalTitle">Add New Manager</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="managerForm" enctype="multipart/form-data">
                    <input type="hidden" id="managerId">
                    <div class="form-group">
                        <label>Profile Image</label>
                        <div class="custom-file">
                            <input type="file" class="custom-file-input" id="profileImage" accept="image/*">
                            <label class="custom-file-label" for="profileImage">Choose file</label>
                        </div>
                        <small class="form-text text-muted">Maximum file size: 2MB. Supported formats: JPG, PNG</small>
                        <div class="mt-2">
                            <img id="imagePreview" src="/static/img/default-avatar.png" 
                                 class="rounded-circle" width="100" height="100" style="display: none;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" class="form-control" id="managerName" required>
                    </div>
                    <div class="form-group">
                        <label>Email</label>
                        <input type="email" class="form-control" id="managerEmail" required>
                    </div>
                    <div class="form-group">
                        <label>Department</label>
                        <select class="form-control" id="managerDepartment" required>
                            <c:forEach items="${departments}" var="dept">
                                <option value="${dept}">${dept}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Employee ID</label>
                        <input type="text" class="form-control" id="employeeId" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control" id="managerStatus">
                            <option value="ACTIVE">Active</option>
                            <option value="INACTIVE">Inactive</option>
                        </select>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveManagerBtn">Save</button>
            </div>
        </div>
    </div>
</div>

<!-- Assign Students Modal -->
<div class="modal fade" id="assignStudentsModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Assign Students</h5>
                <button type="button" class="close" data-dismiss="modal">
                    <span>&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <div class="input-group">
                        <input type="text" class="form-control" id="studentSearch" placeholder="Search students...">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary" type="button" id="clearSearch">
                                <i class="bi bi-x"></i>
                            </button>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>
                                    <div class="custom-control custom-checkbox">
                                        <input type="checkbox" class="custom-control-input" id="selectAllStudents">
                                        <label class="custom-control-label" for="selectAllStudents"></label>
                                    </div>
                                </th>
                                <th>Name</th>
                                <th>ID</th>
                                <th>Program</th>
                                <th>Current Manager</th>
                            </tr>
                        </thead>
                        <tbody id="studentTableBody"></tbody>
                    </table>
                </div>
                <div id="noStudentsMessage" class="text-center p-3" style="display: none;">
                    <p class="text-muted">No students found matching your search.</p>
                </div>
            </div>
            <div class="modal-footer">
                <span class="mr-auto text-muted">
                    Selected: <span id="selectedCount">0</span> students
                </span>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveAssignmentsBtn">Save Assignments</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    // Initialize tooltips and form validation
    $('[data-toggle="tooltip"]').tooltip();
    
    if($.validator) {
        initializeFormValidation();
    }

    // Image preview handling
    $('#profileImage').change(function(e) {
        const file = e.target.files[0];
        if (file) {
            if (file.size > 2 * 1024 * 1024) {
                showToast('Error', 'File size exceeds 2MB limit');
                this.value = '';
                return;
            }
            
            const reader = new FileReader();
            reader.onload = function(e) {
                $('#imagePreview').attr('src', e.target.result).show();
            };
            reader.readAsDataURL(file);
            $('.custom-file-label').text(file.name);
        }
    });

    // Handle search and filters with debounce
    let searchTimeout;
    $('#managerSearch, #departmentFilter, #statusFilter').on('input change', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            loadManagers(1);
        }, 300);
    });

    // Student search handling
    $('#studentSearch').on('input', function() {
        clearTimeout(searchTimeout);
        searchTimeout = setTimeout(function() {
            const searchTerm = $(this).val().toLowerCase();
            filterStudents(searchTerm);
        }, 300);
    });

    $('#clearSearch').click(function() {
        $('#studentSearch').val('');
        filterStudents('');
    });

    // Select all students handling
    $('#selectAllStudents').change(function() {
        const isChecked = $(this).is(':checked');
        $('#studentTableBody input[type="checkbox"]').prop('checked', isChecked);
        updateSelectedCount();
    });

    $(document).on('change', '#studentTableBody input[type="checkbox"]', function() {
        updateSelectedCount();
    });

    // Add Manager button click
    $('#addManagerBtn').click(function() {
        $('#managerModalTitle').text('Add New Manager');
        $('#managerForm')[0].reset();
        $('#managerId').val('');
        $('#imagePreview').hide();
        $('.custom-file-label').text('Choose file');
        $('#managerModal').modal('show');
    });

    // Edit Manager button click
    $(document).on('click', '.edit-manager-btn', function() {
        const managerId = $(this).data('manager-id');
        $('#managerModalTitle').text('Edit Manager');
        loadManagerDetails(managerId);
    });

    // Save manager with image upload
    $('#saveManagerBtn').click(function() {
        if ($.validator && !$('#managerForm').valid()) {
            return;
        }

        const formData = new FormData();
        const managerId = $('#managerId').val();
        
        formData.append('name', $('#managerName').val());
        formData.append('email', $('#managerEmail').val());
        formData.append('department', $('#managerDepartment').val());
        formData.append('employeeId', $('#employeeId').val());
        formData.append('status', $('#managerStatus').val());
        
        const profileImage = $('#profileImage')[0].files[0];
        if (profileImage) {
            formData.append('profileImage', profileImage);
        }

        $.ajax({
            url: managerId ? `/admin/managers/${managerId}` : '/admin/managers',
            method: managerId ? 'PUT' : 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                $('#managerModal').modal('hide');
                loadManagers(1);
                showToast('Success', 'Manager saved successfully');
            },
            error: function(xhr) {
                showToast('Error', xhr.responseText || 'Failed to save manager');
            }
        });
    });

    // Delete Manager
    $(document).on('click', '.delete-manager-btn', function() {
        const managerId = $(this).data('manager-id');
        if (confirm('Are you sure you want to delete this manager?')) {
            $.ajax({
                url: `/admin/managers/${managerId}`,
                method: 'DELETE',
                success: function() {
                    loadManagers(1);
                    showToast('Success', 'Manager deleted successfully');
                },
                error: function(xhr) {
                    showToast('Error', xhr.responseText || 'Failed to delete manager');
                }
            });
        }
    });

    // Assign Students
    $(document).on('click', '.assign-students-btn', function() {
        const managerId = $(this).data('manager-id');
        loadAvailableStudents(managerId);
        $('#assignStudentsModal').modal('show');
    });

    // Save Student Assignments
    $('#saveAssignmentsBtn').click(function() {
        const managerId = $('#assignStudentsModal').data('manager-id');
        const selectedStudents = [];
        $('#studentTableBody input[type="checkbox"]:checked').each(function() {
            selectedStudents.push($(this).val());
        });

        $.ajax({
            url: `/admin/managers/${managerId}/assign-students`,
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify(selectedStudents),
            success: function() {
                $('#assignStudentsModal').modal('hide');
                loadManagers(1);
                showToast('Success', 'Students assigned successfully');
            },
            error: function(xhr) {
                showToast('Error', xhr.responseText || 'Failed to assign students');
            }
        });
    });

    // Pagination
    $(document).on('click', '.pagination button', function() {
        const page = $(this).data('page');
        loadManagers(page);
    });

    // Initial load
    loadManagers(1);
});

function loadManagers(page) {
    const searchTerm = $('#managerSearch').val();
    const department = $('#departmentFilter').val();
    const status = $('#statusFilter').val();

    $.get('/admin/managers/search', {
        term: searchTerm,
        department: department,
        status: status,
        page: page - 1,
        size: 10
    }, function(response) {
        $('#managerTableBody').html(response);
        updatePagination(page);
    }).fail(function() {
        showToast('Error', 'Failed to load managers');
    });
}

function loadManagerDetails(managerId) {
    $.get(`/admin/managers/${managerId}`, function(manager) {
        $('#managerId').val(manager.id);
        $('#managerName').val(manager.name);
        $('#managerEmail').val(manager.email);
        $('#managerDepartment').val(manager.department);
        $('#employeeId').val(manager.employeeId);
        $('#managerStatus').val(manager.status);
        
        if (manager.profileImage) {
            $('#imagePreview').attr('src', manager.profileImage).show();
        } else {
            $('#imagePreview').attr('src', '/static/img/default-avatar.png').show();
        }
        
        $('#managerModal').modal('show');
    }).fail(function() {
        showToast('Error', 'Failed to load manager details');
    });
}

function loadAvailableStudents(managerId) {
    $('#assignStudentsModal').data('manager-id', managerId);
    
    $.get(`/admin/managers/${managerId}/available-students`, function(students) {
        const tbody = $('#studentTableBody');
        tbody.empty();
        
        if (students.length === 0) {
            $('#noStudentsMessage').show();
            return;
        }
        
        $('#noStudentsMessage').hide();
        
        students.forEach(function(student) {
            tbody.append(`
                <tr>
                    <td>
                        <div class="custom-control custom-checkbox">
                            <input type="checkbox" class="custom-control-input" id="student-${student.id}" value="${student.id}">
                            <label class="custom-control-label" for="student-${student.id}"></label>
                        </div>
                    </td>
                    <td>${student.name}</td>
                    <td>${student.studentId}</td>
                    <td>${student.program}</td>
                    <td>${student.currentManager || '-'}</td>
                </tr>
            `);
        });
        
        updateSelectedCount();
    }).fail(function() {
        showToast('Error', 'Failed to load available students');
    });
}

function filterStudents(searchTerm) {
    const rows = $('#studentTableBody tr');
    let hasVisibleRows = false;

    rows.each(function() {
        const text = $(this).text().toLowerCase();
        const isVisible = text.includes(searchTerm);
        $(this).toggle(isVisible);
        if (isVisible) hasVisibleRows = true;
    });

    $('#noStudentsMessage').toggle(!hasVisibleRows);
}

function updateSelectedCount() {
    const count = $('#studentTableBody input[type="checkbox"]:checked').length;
    $('#selectedCount').text(count);
    $('#saveAssignmentsBtn').prop('disabled', count === 0);
}

function updatePagination(currentPage) {
    // This function would update the pagination display
    const totalItems = $('#totalCount').text();
    const pageSize = 10;
    const totalPages = Math.ceil(totalItems / pageSize);
    
    const start = (currentPage - 1) * pageSize + 1;
    const end = Math.min(currentPage * pageSize, totalItems);
    
    $('#startCount').text(start);
    $('#endCount').text(end);
}

function initializeFormValidation() {
    $('#managerForm').validate({
        rules: {
            managerName: {
                required: true,
                minlength: 2
            },
            managerEmail: {
                required: true,
                email: true
            },
            employeeId: {
                required: true,
                pattern: /^EMP\d{4}$/
            }
        },
        messages: {
            managerName: {
                required: "Please enter manager name",
                minlength: "Name must be at least 2 characters"
            },
            managerEmail: {
                required: "Please enter email address",
                email: "Please enter a valid email"
            },
            employeeId: {
                required: "Please enter employee ID",
                pattern: "Format should be EMP followed by 4 digits"
            }
        },
        errorElement: 'span',
        errorPlacement: function(error, element) {
            error.addClass('invalid-feedback');
            element.closest('.form-group').append(error);
        },
        highlight: function(element) {
            $(element).addClass('is-invalid');
        },
        unhighlight: function(element) {
            $(element).removeClass('is-invalid');
        }
    });
}

function showToast(title, message, isSuccess) {
    const toast = document.getElementById('notificationToast');
    const toastTitle = document.getElementById('toastTitle');
    const toastMessage = document.getElementById('toastMessage');
    const toastHeader = toast.querySelector('.toast-header');
    
    // Set content
    toastTitle.textContent = title;
    toastMessage.textContent = message;
    
    // Set header color based on status
    toastHeader.className = 'toast-header ' + (isSuccess ? 'bg-success' : 'bg-danger') + ' text-white';
    
    // Show toast
    $(toast).toast('show');
}
</script> 