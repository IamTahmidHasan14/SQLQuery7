SELECT * FROM tblEmp;
SELECT * FROM students;

--1
CREATE PROCEDURE EmpBySalary
AS
BEGIN
    SELECT EmpSalary FROM tblEmp;
END;

EXEC EmpBySalary

--2
CREATE PROCEDURE CGPAOfStudentsByDept @dept VARCHAR(50), @cgpa FLOAT OUTPUT
AS
BEGIN
    SELECT @cgpa = MAX(CGPA)
    FROM Students
    WHERE Dept = @dept AND CGPA < (SELECT MAX(CGPA) FROM Students WHERE Dept = @dept);
END;

DECLARE @SecondHighestCGPA DECIMAL(5, 2);
EXEC CGPAOfStudentsByDept 'CSE', @SecondHighestCGPA OUTPUT;
PRINT 'Second Highest CGPA: ' + CAST(@SecondHighestCGPA AS NVARCHAR(10));


--3
CREATE PROCEDURE EmpJoiningDate
(
    @SalaryThreshold DECIMAL(18, 2),
    @EmployeeNames NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    DECLARE @SixMonthsAgo DATE = DATEADD(MONTH, -6, GETDATE());

    SELECT @EmployeeNames = COALESCE(@EmployeeNames + ', ', '') + EmpName
    FROM tblEmp
    WHERE EmpJoinDate < @SixMonthsAgo AND EmpSalary > @SalaryThreshold;

    IF @EmployeeNames IS NULL
    BEGIN
        SET @EmployeeNames = 'No employees found.';
    END
END;

DECLARE @EmployeeNames NVARCHAR(MAX);
EXEC EmpJoiningDate 20000, @EmployeeNames OUTPUT;
PRINT 'Employees joined before 6 months ago with salary > 20000: ' + ISNULL(@EmployeeNames, 'No employees found.');


--4
CREATE PROCEDURE totalCseStudent
(
    @CGPAThreshold DECIMAL(5, 2),
    @StudentList NVARCHAR(MAX) OUTPUT
)
AS
BEGIN
    DECLARE @Department NVARCHAR(50) = 'CSE';

    SELECT @StudentList = COALESCE(@StudentList + ', ', '') + SNAME
    FROM students
    WHERE Dept = @Department AND CGPA > @CGPAThreshold;

    IF @StudentList IS NULL
    BEGIN
        SET @StudentList = 'No students found.';
    END
END;

DECLARE @StudentList NVARCHAR(MAX);
EXEC totalCseStudent 3.6, @StudentList OUTPUT;
PRINT 'CSE Students with CGPA > 3.6: ' + ISNULL(@StudentList, 'No students found.');

--5
EXEC sp_depends 'tblEmp';
EXEC sp_depends 'Students';
