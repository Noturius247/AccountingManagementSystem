package com.accounting.repository;

import com.accounting.model.Student;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface StudentRepository extends JpaRepository<Student, Long> {

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.registrationStatus = :status")
    List<Student> findByRegistrationStatus(@Param("status") Student.RegistrationStatus status);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.registrationStatus = :status")
    Page<Student> findByRegistrationStatus(@Param("status") Student.RegistrationStatus status, Pageable pageable);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.program = :program")
    Page<Student> findByProgram(@Param("program") String program, Pageable pageable);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.registrationStatus = :status AND s.program = :program")
    Page<Student> findByRegistrationStatusAndProgram(
        @Param("status") Student.RegistrationStatus status,
        @Param("program") String program,
        Pageable pageable
    );

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE (s.fullName LIKE %:search% OR s.studentId LIKE %:search%) AND s.registrationStatus = :status AND s.program = :program")
    Page<Student> findByFullNameContainingOrStudentIdContainingAndRegistrationStatusAndProgram(
        @Param("search") String search,
        @Param("search") String studentIdSearch,
        @Param("status") Student.RegistrationStatus status,
        @Param("program") String program,
        Pageable pageable
    );

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.studentId = :studentId")
    Optional<Student> findByStudentId(@Param("studentId") String studentId);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.user.id = :userId")
    Optional<Student> findByUserId(@Param("userId") Long userId);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.username = :username")
    Optional<Student> findByUsername(@Param("username") String username);

    @Query("SELECT COUNT(s) FROM Student s WHERE s.registrationStatus = :status")
    long countByRegistrationStatus(@Param("status") Student.RegistrationStatus status);

    boolean existsByStudentId(String studentId);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user")
    List<Student> findAll();

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user")
    Page<Student> findAll(Pageable pageable);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user WHERE s.id = :id")
    Optional<Student> findById(@Param("id") Long id);

    @Query("SELECT CASE WHEN COUNT(s) > 0 THEN true ELSE false END FROM Student s WHERE s.user.id = :userId")
    boolean existsByUserId(@Param("userId") Long userId);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user LEFT JOIN FETCH s.manager WHERE s.manager.id = :managerId")
    List<Student> findByManagerId(@Param("managerId") Long managerId);

    @Query("SELECT COUNT(s) FROM Student s WHERE s.manager.id = :managerId")
    long countByManagerId(@Param("managerId") Long managerId);

    @Query("SELECT s FROM Student s LEFT JOIN FETCH s.user LEFT JOIN FETCH s.manager WHERE s.manager IS NULL")
    List<Student> findStudentsWithoutManager();
} 